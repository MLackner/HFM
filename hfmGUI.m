function hfmGUI()
%hfmGUI
%
%   Open a GUI for the layer heat flow model
%

% Data is shared between all child functions by declaring the variables
% here (they become global to the function). We keep things tidy by putting
% all GUI stuff in one structure and all data stuff in another. As the app
% grows, we might consider making these objects rather than structures.
data = createData(  );
gui = createInterface(  );

% Now update the GUI with the current data
updateInterface();

%-------------------------------------------------------------------------%
    function data = createData()
        % Add folders to search path
        addpath([pwd,'/layout'], [pwd,'/data'])
        % Get the system defined monospaced font
        data.MonoFont = get(0, 'FixedWidthFontName');
        
        % Create View Modes that are shown in the listbox in the view
        % control panel
        data.viewModesBC = { ...
            'Materials', ...
            'Beam Profile (spatial)', ...
            'Beam Profile (time)', ...
            'Beam Absorption' };
        
        data.viewModesSim = { ...
            'T Dissipation on Surface 3D', ...
            'T on Surface (center) 2D', ...
            'T in yz plane 3D' };
        
    end % Create Data

%-------------------------------------------------------------------------%
    function gui = createInterface()
        % Create the user interface for the application and return a
        % structure of handles for global use.
        gui = struct();
        % Open a window and add some menus
        gui.Window = figure( ...
            'Name', 'HeaFlMoFoLaySy', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'figure', ...
            'HandleVisibility', 'off', ...
            'Position', [200, 200, 1200, 400] );
        
        % + File menu
        gui.FileMenu = uimenu( gui.Window, 'Label', 'File' );
        uimenu( gui.FileMenu, 'Label', 'Run Simulation', ...
            'Callback', @onRunSimulation );
        uimenu( gui.FileMenu, 'Label', 'Edit Settings ...', ...
            'Separator', 'on', 'Callback', @onBCondEdit );
        uimenu( gui.FileMenu, 'Label', 'Load Settings ...', ...
            'Callback', @onBCondLoad );
        uimenu( gui.FileMenu, 'Label', 'Exit', ...
            'Separator', 'on', 'Callback', @onExit );        
        
        % Arrange the main interface
        mainLayout = uix.HBoxFlex( 'Parent', gui.Window, 'Spacing', 3 );
        
        % + Create the panels
        controlPanel = uix.BoxPanel( ...
            'Parent', mainLayout, ...
            'Title', 'Boundary Conditions' );
        gui.ViewPanel = uix.BoxPanel( ...
            'Parent', mainLayout, ...
            'Title', 'View' );
        gui.ViewContainer = uicontainer( ...
            'Parent', gui.ViewPanel );
        gui.ViewControls = uix.BoxPanel( ...
            'Parent', mainLayout, ...
            'Title', 'View Controls' );

        % + Adjust the main layout
        set( mainLayout, 'Widths', [-1,-1.5,-1]  );
        
        
        % + Create the boundary condition controls
        controlLayout = uix.VBox( 'Parent', controlPanel, ...
            'Padding', 3, 'Spacing', 3 );
        gui.BCondInfo = uicontrol( 'Parent', controlLayout, ...
            'Style', 'text', 'FontName', data.MonoFont, ...
            'BackgroundColor', 'white', ...
            'HorizontalAlignment', 'left' );
        controlButtons = uix.HBox( 'Parent', controlLayout', ...
            'Padding', 3, 'Spacing', 3 );
        gui.BCondEdit = uicontrol( 'Parent', controlButtons, ...
            'Style', 'pushbutton', 'Callback', @onBCondEdit, ...
            'String', 'Edit BC' );
        gui.BCondLoad = uicontrol( 'Parent', controlButtons, ...
            'Style', 'pushbutton', 'Callback', @onBCondLoad, ...
            'String', 'Load BC' );
        
        % + Adjust the Heigths
        set( controlLayout, 'Heights', [-1 30] );
        
        % + Create the view
        p = gui.ViewContainer;
        gui.ViewAxes = axes( 'Parent', p );
        
        % + Create the view control panel controls
        viewControlLayout = uix.VBox( 'Parent', gui.ViewControls, ...
            'Padding', 3, 'Spacing', 3 );
        gui.ViewMode = uicontrol( 'Parent', viewControlLayout, ...
            'Style', 'listbox', ...
            'Callback', @onViewSelect, ...
            'String', data.viewModesBC );
        gui.SelectData = uicontrol( 'Parent', viewControlLayout, ...
            'Style', 'pushbutton', ...
            'Callback', @onSelectData, ...
            'String', 'Select data ...' );
        timeControl = uix.HBox( 'Parent', viewControlLayout, ...
            'Padding', 3, 'Spacing', 3 );
        gui.ToStart = uicontrol( 'Parent', timeControl, ...
            'Style', 'pushbutton', ...
            'Callback', @onToStart, ...
            'String', '<<' );
        gui.Play = uicontrol( 'Parent', timeControl, ...
            'Style', 'pushbutton', ...
            'Callback', @onPlay, ...
            'String', '-->' );
        gui.ToEnd = uicontrol( 'Parent', timeControl, ...
            'Style', 'pushbutton', ...
            'Callback', @onToEnd, ...
            'String', '>>' );
        gui.Slower = uicontrol( 'Parent', timeControl, ...
            'Style', 'pushbutton', ...
            'Callback', @onSlower, ...
            'String', '-' );
        gui.Faster = uicontrol( 'Parent', timeControl, ...
            'Style', 'pushbutton', ...
            'Callback', @onFaster, ...
            'String', '+' );
        
        % + Adjust the heights
        set( viewControlLayout, 'Heights', [-1 30 30] );
        
    end % createInterface

%-------------------------------------------------------------------------%
    function updateInterface()
        % Update various parts of the interface in response to boundary
        % conditons being changed
        
        % + Update boundary conditions information if the data exists. (It
        % doesn't when the program starts)
        if isfield( data, 'bc' )
            % Simplify data strucure for easier access to boundary
            % condition data
            q = data.bc;
            % Format the text that shall be displayed
            InfoString = sprintf( ...
                ['Time Settings\n\tTotal sim. time: %g s\n', ...
                '\tNumber of time steps: %g\n', ...
                'System Dimensions\n\tX length: %g m\n', ...
                '\tY length: %g m\n', ...
                '\tZ length: %g m\n' ], ...
                q.t, ...
                q.Nt, ...
                q.l(1), ...
                q.l(2), ...
                q.l(3) );
            % Apply the string to the text control
            set( gui.BCondInfo, 'String', InfoString );
        end % Update boundary conditions
        
        % + Update the view modes listbox
        set( gui.ViewMode, 'String', data.viewModes );
        
    end % updateInterface

%-------------------------------------------------------------------------%
    function redrawView()
        % Draw a demo into the axes provided
        
        % We first clear the existing axes ready to build a new one
        if ishandle( gui.ViewAxes )
            delete( gui.ViewAxes );
        end
        
        % Get rid of the opened figure
        close( fig );
    end % redrawDemo
%-------------------------------------------------------------------------%
    function processParameters()
        % Process the parameters that are passed via the setup file/script.
                
        % Calculate the distance betweeen two simulated elements. Output is 
        % an
        % array d = [xdir -xdir ydir -ydir zdir -zdir] where xdir and -xdir etc.
        % are the same values.
        data.pr.d(1:2) = data.bc.l(1)/data.bc.N(1);
        data.pr.d(3:4) = data.bc.l(2)/data.bc.N(2);
        data.pr.d(5:6) = data.bc.l(3)/data.bc.N(3);
        
        % Calculate the volume of one element
        data.pr.V = data.pr.d(1)*data.pr.d(3)*data.pr.d(5);
        
        % Calculate the area per dimension (Same format as distances between
        % elements.
        % X Dimension
        data.pr.A(1:2) = data.pr.d(3)*data.pr.d(5);
        % Y Dimension
        data.pr.A(3:4) = data.pr.d(1)*data.pr.d(5);
        % Z Dimension
        data.pr.A(5:6) = data.pr.d(1)*data.pr.d(3);
        
        % Calculate time of each time step
        data.pr.dt = data.bc.t/data.bc.Nt;
        %%
        % Generate a Matrix with ambient temperatures as base for the calculations.
        % The size of the matrix is two elements bigger in every dimension because
        % the edges can either be adiabatic or have a constant temperature.
        data.pr.M = ...
            zeros(data.bc.N(1)+2,data.bc.N(2)+2,data.bc.N(3)+2) ...
            + data.bc.T0;
        %%
        % Calculate the layer where the materials change.
        data.bc.dLayer(length(data.bc.dLayer)+1) = ...
            data.bc.l(3) - sum(data.bc.dLayer);
        %%
        % Preallocation
        data.pr.Nlayer = zeros(1,length(data.bc.dLayer));
        for i=1:length(data.bc.dLayer)
            if i==1
                NlayerPrev = 1;
            else
                NlayerPrev = data.pr.Nlayer(i-1);
            end
            data.pr.Nlayer(i) = ...
                round(data.bc.dLayer(i)/data.pr.d(6)) + NlayerPrev;
            if i==length(data.bc.dLayer)
                % Make sure the whole matrix is filled
                data.pr.Nlayer(i) = size(data.pr.M,3);
            end
        end
        %%
        % Define a Material matrix in the same size as the temperature 
        % matrix M.
        data.pr.Mat = zeros(size(data.pr.M));
        % Define Materials
        for i=length(data.bc.dLayer):-1:1
            data.pr.Mat(:,:,1:data.pr.Nlayer(i)) = i;
        end
        %%
        % For each material calculate the mass of a single volume element.
        data.pr.m = zeros(1,length(data.bc.dLayer));
        for i=1:length(data.bc.dLayer)
            data.pr.m(i) = data.bc.rho(i)*data.pr.V;
        end
        
        % Define matrices with material constants
        data.pr.K = zeros(size(data.pr.M));
        data.pr.C = zeros(size(data.pr.M));
        data.pr.MV = zeros(size(data.pr.M));
        data.pr.AC = zeros(size(data.pr.M));
        for i=1:numel(data.pr.Mat)
            data.pr.material = data.pr.Mat(i);
            data.pr.K(i) = data.bc.k(data.pr.material);
            data.pr.C(i) = data.bc.c(data.pr.material);
            data.pr.MV(i) = data.pr.m(data.pr.material);
            data.pr.AC(i) = data.bc.absCoeff(data.pr.material);
        end
        
        % Convert the thermal conductivity matrix in a 4D matrix in which the
        % heatflow is given in every direction
        data.pr.K = K3(data.pr.K);
        
        % Calculate a beam absorption (I) and an intensity (I2) matrix
        [data.pr.I,data.pr.I2] = ...
            beamAbs(data.bc.l,data.bc.N,data.bc.beamDia,data.pr.AC);
        
    end % processParameters
%-------------------------------------------------------------------------%

%
%   Callbacks
%
%-------------------------------------------------------------------------%
    function onExit( ~, ~ )
        % User wants to quit out of the application
        delete( gui.Window );
    end % onExit

    function onSelectData( ~, ~ )
        % Get folder of simulated data set and add View Options to the view
        % mode listbox.
        
        % Get folder
        [~,PathName,~] = ...
            uigetfile( '*.mat','Load Simulated Data', ...
            data.bc.pathName );
        
        % Save folder in data structure
        data.DataSet = PathName;
        
        % Add view modes
        data.viewModes = [data.viewModesBC data.viewModesSim];
        
        % Update Interface
        updateInterface();
        
    end % onSelectData

    function onBCondEdit( ~, ~)
        % On button press the *.m file opens and on execution it saves
        % to as specified in a save file dialog.
        
        % Open the default setup file
        edit data/defaultSetup.m
        
    end % onBCondEdit

    function onBCondLoad( ~, ~ )
        % Load boundary conditions from a specific setup file. The
        % parameters are then processed automatically.
        
        % Get file path and name
        [FileName,PathName,~] = ...
            uigetfile( '*.mat','Load Boundary Conditions', ...
            'data/' );
        
        % Load the data
        data.bc = load( [PathName, '/', FileName] );
        
        % Process parameters
        processParameters();
        
        % Update the interface
        updateInterface();
        
    end %onCondLoad

    function onRunSimulation( ~, ~ )
        % Run the Simulation. First we make the variables in the data
        % struct easier to access
        
        % Check if there is the specified directory in the defined save path. If
        % not create one. If yes delete all files in this folder.
        % Set path
        data.pr.savePath = [data.bc.pathName,data.bc.folderName];
        if exist(data.pr.savePath,'dir')
            delete([data.pr.savePath,data.bc.fileName,'*.mat'])
        else
            mkdir(data.pr.savePath);
        end
        % Include filename in path
        data.pr.savePath = [data.pr.savePath,data.bc.fileName];
        
        % Parameters
        M = data.pr.M;
        Nt = data.bc.Nt;
        dt = data.pr.dt;
        A = data.pr.A;
        d = data.pr.d;
        K = data.pr.K;
        C = data.pr.C;
        MV = data.pr.MV;
        pulseEnergy = data.bc.pulseEnergy;
        adiabatic = data.bc.adiabatic;
        I = data.pr.I;
        savePath = data.pr.savePath;
        saveSteps = data.bc.saveSteps;
        T0 = data.bc.T0;
        
        % Prerun model for time estimate
        estimateRunTime(M,Nt,dt,A,d,K,C,MV,pulseEnergy,adiabatic,I, ...
            savePath,saveSteps)
        
        % Run model
        [Y] = heatflow(M,Nt,dt,A,d,K,C,MV,pulseEnergy,adiabatic,I, ...
            savePath,saveSteps);
        
        % Calculate total excess heat remaining in system
        sumUpEnergy(Y,T0,C,MV)
        
        % Update interface
        updateInterface();
        
    end % onRunSimulation

% View Control Panel
%---------------------------------------------------------------------%
    function onViewSelect( ~, ~ )
        % Get the selected view mode in the view control listbox. Pass this
        % value to the appropriate draw funtion that actually plots the
        % data.
        
        % Get the selection in the listbox
        val = get( gui.ViewMode, 'Value' );
        % Go to the appropriate function
        if val == 1
            drawMaterials();
        elseif val == 2
            drawBeamProfileS();
        elseif val == 3
            drawBeamProfileT();
        elseif val == 4
            drawAbsorption();
        elseif val == 5
            drawTDissOnSurf();
        elseif val == 6
            drawTonSurface();
        elseif val == 7
            drawTinYZ();
        else
            return
        end
        
    end % onViewSelect

%
%   Draw Funtions
%
%-------------------------------------------------------------------------%
    function drawMaterials
        % 3D view of the outer edges of the systems. The layers are
        % represented by different colors.
        
        % Get the Material matrix
        v = data.pr.Mat(2:end-1,2:end-1,2:end-1);
        [x,y,z] = getXYZ;
        % Make the slices
        xslice = [0 data.bc.l(1)];
        yslice = [0 data.bc.l(2)];
        zslice = [0 data.bc.l(3)];
        % Get the axes handle
        h = gui.ViewAxes;
        % Plot
        p = slice(h,x,y,z,v,xslice,yslice,zslice);
        % Label the axes
        xlabel(h,'X [m]'); ylabel(h,'Y [m]'); zlabel(h,'Z [m]');
        legend(h, data.bc.names)
        % Edit the properties of all slices
        for i=1:numel(p)
            % Modify the grid lines
            p(i).LineStyle = '-';
            % Make the edges transparent
            p(i).EdgeAlpha = 0.5;
        end
    end % drawMaterials

    function drawBeamProfileS
        % 3D mesh plot of the spatial beam profile in xy plane
        
        % Get the absorption data of the first non-dummy layer
        z = data.pr.I(2:end-1,2:end-1,2);
        % Get x and y data
        [x,y,~] = getXYZ;
        % Get the axes handle
        h = gui.ViewAxes;
        % Plot
        p = surf( h, x,y,z );
        % Label the axes
        xlabel(h,'X [m]'); ylabel(h,'Y [m]'); 
        zlabel(h,'Intensity [a.u.]');
                       
    end % drawBeamProfileS

    function drawBeamProfileT
        % 2D line plot of the beam profile over the entire simulation time
        % Get time data
        x = 0:data.pr.dt:data.bc.t;
        % Calculate power data
        y = heatInduction( x, data.bc.pulseEnergy );
        % Get axes handle
        h = gui.ViewAxes;
        % Plot
        p = plot( h, x,y );
        % Label axes
        xlabel( h, 'Time [s]' ), ylabel( h, 'Power [W]' )
        % Set x axis limit
        xlim( h, [0 data.bc.pulseDuration*1.5] )
        % Manipulate line plot
        p.LineWidth = 3;
        
    end % drawBeamProfileT

    function drawAbsorption
        
        % Calculate center of xy plane
        center = [floor((data.bc.N(1)+2)/2) floor((data.bc.N(2)+2)/2)];
        % Get z data
        [ ~,~,z] = getXYZ;
        % Get y data
        y = squeeze( data.pr.I2(center(1),center(2),2:end-1));
        % Get handle
        h = gui.ViewAxes;
        % Plot
        p = plot( h, z,y );
        % Labels
        xlabel( h, 'Z [m]' )
        ylabel( h, 'I/I_0' )
        % Manipulate line plot
        p.LineWidth = 3;
        % Flip x axis
        set( h, 'XDir', 'reverse' )
        
    end % drawAbsorption

    function drawTDissOnSurf()
        % Make xy data
        xy = zeros( data.bc.N(1),data.bc.N(2) );
        
        % Get handle
        h = gui.ViewAxes;
        zlim( h, [data.bc.T0 340] )
        % Labels
        xlabel( h,'X' )
        ylabel( h,'Y' )
        for i=1:250
            % Load time step
            loadData(i)
            z = squeeze( data.TimeStep(2:end-1,2:end-1,2) );
            % Plot
            surf( h, z );
            zlim( h, [data.bc.T0 340] )
            title( h, sprintf( '%g', i ) )
            pause(0.01)
        end % Plot
        
    end % drawTDissOnSurf

    function drawTonSurface()
        
        % Make time data
        x = 0:data.pr.dt*data.bc.saveSteps:data.bc.t;
        
        % Preallocate Temperature data
        y = zeros( 1,length(x) );
        % Get the center of the system
        loadData(1)
        center = floor((size(data.TimeStep,1)+2)/2);
        
        % Get the surface, and the interfaces between the several layers
        % Preallocate layers array
        layer = zeros(1,numel(data.bc.N));
        % The first layer (surface) is always on 2nd position
        layer(1) = 2;
        % Get the interfaces
        for i=2:numel(data.bc.N)
            layer(i) = 2 + data.pr.Nlayer(i-1);
        end
        
        % Load Temperature data from the saved files
        for j=1:length(layer)
            for i=1:length(x)
                % Load time step
                loadData(i)
                y(i,j) = squeeze( data.TimeStep(center,center,layer(j)) );
            end % Load files
        end
        
        % Get handle
        h = gui.ViewAxes;
        for i=1:length(layer)
            % Plot
            p(i) = plot( h, x,y(:,i)' );
            hold(h, 'on')
            % Modify line plot
            p(i).LineWidth = 3;
            % Display Name
            % Make string
            dispString = sprintf('Layer %g (%s)', ...
                layer(i),data.bc.names{i} );
            p(i).DisplayName = dispString;
        end % Plot
        hold( h, 'off' )
        % Labels
        xlabel( h,'Time [s]' )
        ylabel( h,'Temperature [K]' )
        % Legend
        legend(h, 'show', 'Location', 'northwest' )
        
    end % drawTonSurface

    function drawTinYZ()
        % Make xy data
        xy = zeros( data.bc.N(1),data.bc.N(2) );
        
        % Get the center of the system
        loadData(1)
        center = floor((size(data.TimeStep,1)+2)/2);
        % Get seconds per time step
        dtStep = data.pr.dt*data.bc.saveSteps;
        
        % Get handle
        h = gui.ViewAxes;
        zlim( h, [data.bc.T0 340] )
        % Labels
        xlabel( h,'X' )
        ylabel( h,'Y' )
        for i=1:250
            % Load time step
            loadData(i)
            z = squeeze( data.TimeStep(center,2:end-1,2:end-1) );
            % Plot
            surf( h, z );
            zlim( h, [data.bc.T0 340] )
            % Make title
            secs = i*dtStep - dtStep;
            title( h, sprintf( '%g s', secs) )
            view( h, [0 90] )
            
            pause(0.01)
        end % Plot
        
    end % drawTinXY

    function [x,y,z] = getXYZ()
        % Get x, y and data arrays (units in meters)
        % Create the x dimension data
        x = linspace(0,data.bc.l(1),data.bc.N(1));
        % Create the y dimension data
        y = linspace(0,data.bc.l(2),data.bc.N(2));
        % Create the z dimension data (flip bottom to the top)
        z = linspace(data.bc.l(3),0,data.bc.N(3));
    end % getXY

    function loadData(i)
        
        % Get the full path where the files are localized
        fullPath = [data.bc.pathName,data.bc.folderName,data.bc.fileName];
        % Load Time Step
        S = load([fullPath,int2str(i),'.mat']);
        % Save Time Step to data struct
        data.TimeStep = S.M;
        
    end % loadData
    
end % GUI main function
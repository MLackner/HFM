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
        data.viewModes = { ...
            'Materials', ...
            'Beam Profile (spatial)', ...
            'Beam Profile (time)', ...
            'Beam Absorption' };
        
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
            'String', data.viewModes );
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
        
        % Run the simulation
        ProcessParametersFcn(data.bc);
        
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
        data.pr
        data.bc
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

    function [x,y,z] = getXYZ()
        % Get x, y and data arrays (units in meters)
        % Create the x dimension data
        x = linspace(0,data.bc.l(1),data.bc.N(1));
        % Create the y dimension data
        y = linspace(0,data.bc.l(2),data.bc.N(2));
        % Create the z dimension data (flip bottom to the top)
        z = linspace(data.bc.l(3),0,data.bc.N(3));
    end % getXY
    
end % GUI main function
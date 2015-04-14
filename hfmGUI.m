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
            'Beam Absorption', ...
            'Thermal Conductivity' };
        
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
        % Load boundary conditions from a specific setup file.
        [FileName,PathName,~] = ...
            uigetfile( '*.mat','Load Boundary Conditions', ...
            'data/' );
        
        % Load the data
        data.bc = load( [PathName, '/', FileName] );
        
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
        
    end % drawMaterials
    
end % GUI main function
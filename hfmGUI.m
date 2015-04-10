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
        data.MonoFont = get(0, 'FixedWidthFontName');
        
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
            'Toolbar', 'none', ...
            'HandleVisibility', 'off' );
        
        % + File menu
        gui.FileMenu = uimenu( gui.Window, 'Label', 'File' );
        uimenu( gui.FileMenu, 'Label', 'Exit', 'Callback', @onExit );        
        
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

        % + Adjust the main layout
        set( mainLayout, 'Widths', [-1,-2]  );
        
        
        % + Create the boundary condition controls
        controlLayout = uix.VBox( 'Parent', controlPanel, ...
            'Padding', 3, 'Spacing', 3 );
        gui.BCondInfo = uicontrol( 'Parent', controlLayout, ...
            'Style', 'text', 'FontName', data.MonoFont, ...
            'BackgroundColor', 'white' );
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
        
    end % createInterface

%-------------------------------------------------------------------------%
    function updateInterface()
        % Update various parts of the interface in response to boundary
        % conditons being changed
        
        
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

    function onBCondEdit
        % A get file interface is shown with the default bc as default
        % choice. On selection the *.m file opens and on execution it saves
        % to as specified in a save file dialog. The saved parameters get
        % loaded into the 'data' structure and are displayed in the BC Info
        % panel.
        
        % Open the get file dialog
        
    end % onBCondEdit

    function onBCondLoad
        % Load boundary conditions from a specific setup file.
end % GUI main function
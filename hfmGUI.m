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
        data = [];
        
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
        
        
        % + Create the controls
        controlLayout = uix.VBox( 'Parent', controlPanel, ...
            'Padding', 3, 'Spacing', 3 );
        gui.ListBox = uitable( 'Parent', controlLayout);
        
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
end % GUI main function
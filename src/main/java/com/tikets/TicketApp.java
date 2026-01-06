package com.tikets;

import com.googlecode.lanterna.screen.Screen;
import com.googlecode.lanterna.terminal.DefaultTerminalFactory;
import com.googlecode.lanterna.TextColor;
import com.googlecode.lanterna.graphics.SimpleTheme;
import com.googlecode.lanterna.graphics.Theme;
import com.googlecode.lanterna.SGR;
import com.googlecode.lanterna.gui2.*;
import com.googlecode.lanterna.gui2.dialogs.MessageDialog;
import com.googlecode.lanterna.TerminalSize;

import java.io.IOException;

public class TicketApp {

    public void loadApp() throws IOException {
        Screen screen = new DefaultTerminalFactory().createScreen();
        screen.startScreen();

        try {
            MultiWindowTextGUI gui = new MultiWindowTextGUI(screen);
            gui.setTheme(createTheme());

            BasicWindow window = new BasicWindow("Ticket");

            Panel root = new Panel();
            root.setLayoutManager(new LinearLayout(Direction.VERTICAL));

            Label title = new Label("Sistema tickets");
            title.addStyle(SGR.BOLD);
            root.addComponent(title);

            Button exitButton = new Button("Salir", window::close);
            root.addComponent(exitButton);
            window.setComponent(root);
            gui.addWindowAndWait(window);
        } finally {
            screen.stopScreen();
        }

    }

    private static Theme createTheme() {
        return SimpleTheme.makeTheme(
                true,
                TextColor.ANSI.WHITE,
                TextColor.ANSI.BLACK,
                TextColor.ANSI.YELLOW,
                TextColor.ANSI.BLUE,
                TextColor.ANSI.WHITE,
                TextColor.ANSI.BLACK,
                TextColor.ANSI.YELLOW);
    }
}

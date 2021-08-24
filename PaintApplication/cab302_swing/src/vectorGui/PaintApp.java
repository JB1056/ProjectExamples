package vectorGui;

import vectorGui.buttonsAndToolBars.buttonPanel;
import vectorGui.buttonsAndToolBars.colorPanel;
import vectorGui.buttonsAndToolBars.toolBar;
import vectorGui.buttonsAndToolBars.fillPanel;
import vectorGui.drawingLogic.drawingArea;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class PaintApp extends JFrame implements Runnable {

    public static final int SIZE = 610;
    public static final int DASIZE = 500;
    public static JFrame f;
    public static drawingArea drawingarea;

    private PaintApp(String title) throws HeadlessException {
        super(title);
    }

    private void createGUI() {

        try {
            UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Build components
        toolBar.buildToolBar();
        drawingarea = new drawingArea();
        buttonPanel buttonpanel = new buttonPanel();
        colorPanel colorpanel = new colorPanel();
        fillPanel fillpanel = new fillPanel();


        //JFrame
        JFrame.setDefaultLookAndFeelDecorated(true);
        f = new JFrame("Vector Paint");
        drawingarea.setPreferredSize(new Dimension(DASIZE, DASIZE));

        // Add Scroll Bar
        JScrollPane scrollPanel = new JScrollPane(drawingarea,
                ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED,
                ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        
        // Add components to window
        f.getContentPane().add(scrollPanel, BorderLayout.CENTER);
        f.getContentPane().add(buttonpanel, BorderLayout.SOUTH);
        f.getContentPane().add(toolBar.toolBar, BorderLayout.NORTH);
        f.getContentPane().add(colorpanel, BorderLayout.WEST);
        f.getContentPane().add(fillpanel, BorderLayout.EAST);

        // resizing to maintain aspect ratio
        f.addComponentListener(new ResizeListener());

        // Cleanup and launch
        f.pack();
        f.setSize(SIZE, SIZE);
        f.setLocationRelativeTo(null);
        f.setVisible(true);
        f.setResizable(true);
        f.setDefaultCloseOperation(EXIT_ON_CLOSE);


    }

    @Override
    public void run() {
        createGUI();
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(new PaintApp("Vector Paint"));
    }

    class ResizeListener extends ComponentAdapter {
        @Override
        public void componentResized(ComponentEvent arg0) {
            Rectangle b = arg0.getComponent().getBounds();
            arg0.getComponent().setBounds(b.x, b.y, b.width, b.width);
        }

    }
}
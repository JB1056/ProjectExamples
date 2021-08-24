package vectorGui.buttonsAndToolBars;

import vectorGui.PaintApp;
import vectorGui.PaintException;
import vectorGui.drawingLogic.drawingArea;
import vectorGui.shapeClasses.ShapeClass;
import vectorGui.vecLogic.readVecFile;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;

public class toolBar extends JFrame {

    public static JMenuBar toolBar = new JMenuBar();
    private final JFileChooser fileChooser = new JFileChooser();
    public static int arrayLocation = drawingArea.shapeList.size() - 1;
    private ArrayList<ShapeClass> redoList = new ArrayList<>();
    private ArrayList<String> vecRedoList = new ArrayList<>();


    public static void buildToolBar() {
        menuHandler handler = new toolBar().new menuHandler(); //create instance of nested class handler

        // File
        JMenu fileMenu = new JMenu("File");
        toolBar.add(fileMenu);

        JMenuItem fileLoad = new JMenuItem("Open");
        fileLoad.addActionListener(handler);
        fileMenu.add(fileLoad);
        fileLoad.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_O, ActionEvent.CTRL_MASK + ActionEvent.SHIFT_MASK));

        JMenuItem fileSave = new JMenuItem("Save");
        fileSave.addActionListener(handler);
        fileMenu.add(fileSave);
        fileSave.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_S, ActionEvent.CTRL_MASK));

        JMenuItem fileExport = new JMenuItem("Export to bmp");
        fileExport.addActionListener(handler);
        fileMenu.add(fileExport);

        // Edit
        JMenu editMenu = new JMenu("Edit");
        toolBar.add(editMenu);

        JMenuItem editUndo = new JMenuItem("Undo");
        editMenu.add(editUndo);
        editUndo.addActionListener(handler);
        editUndo.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_Z, ActionEvent.CTRL_MASK));

        JMenuItem editRedo = new JMenuItem("Redo");
        editMenu.add(editRedo);
        editRedo.addActionListener(handler);
        editRedo.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_R, ActionEvent.CTRL_MASK));
        editRedo.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_Y, ActionEvent.CTRL_MASK));


        // View
        JMenu viewMenu = new JMenu("View");
        toolBar.add(viewMenu);

        JMenuItem zoomIn = new JMenuItem("Zoom +");
        viewMenu.add(zoomIn);
        zoomIn.addActionListener(handler);
        zoomIn.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_EQUALS, ActionEvent.CTRL_MASK));

        JMenuItem zoomOut = new JMenuItem("Zoom -");
        viewMenu.add(zoomOut);
        zoomOut.addActionListener(handler);
        zoomOut.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_MINUS, ActionEvent.CTRL_MASK));
    }

    // function for undoing colors after a shape on vec file
    private void undoColorVec() {
        while (drawingArea.vecList.get(drawingArea.vecList.size() - 1).startsWith("PEN") ||
                drawingArea.vecList.get(drawingArea.vecList.size() - 1).startsWith("FILL")) {
            drawingArea.vecList.remove(drawingArea.vecList.size() - 1);
        }
    }

    // function for adding last used colours on vec file
    private static void redoColorVec() {
        if (fillPanel.setFill != fillPanel.defaultFillColor) {
            drawingArea.vecList.add("FILL " + "#" + Integer.toHexString(fillPanel.setFill.getRGB()).substring(2).toUpperCase());
        }

        if (colorPanel.setColor != colorPanel.defaultpenColor) {
            drawingArea.vecList.add("PEN " + "#" + Integer.toHexString(colorPanel.setColor.getRGB()).substring(2).toUpperCase());
        }
    }

    // function for handling zoom
    private void zoom(JFrame frame, double scale){

        for (ShapeClass shape: drawingArea.shapeList) {

            switch(shape.getType()){
                case "RECTANGLE":
                    double x = shape.getRectangle().getX();
                    double y = shape.getRectangle().getY();
                    double w = shape.getRectangle().getWidth();
                    double h = shape.getRectangle().getHeight();
                    shape.getRectangle().setRect(x + x * scale, y + y * scale, w + w * scale,
                            h + h * scale);
                    frame.repaint();
                    break;
                case "PLOT":
                case "ELLIPSE":
                    double ex = shape.getEllipse().getX();
                    double ey = shape.getEllipse().getY();
                    double ew = shape.getEllipse().getWidth();
                    double eh = shape.getEllipse().getHeight();
                    shape.getEllipse().setFrame(ex + ex * scale, ey + ey * scale, ew + ew * scale,
                            eh + eh * scale);
                    break;
                case "LINE":
                    double x1 = shape.getLine().getX1();
                    double x2 = shape.getLine().getX2();
                    double y1 = shape.getLine().getY1();
                    double y2 = shape.getLine().getY2();
                    shape.getLine().setLine(x1 + x1 * scale, y1 + y1 * scale, x2 + x2 * scale,
                            y2 + y2 * scale);
                    break;
                //polygon zoom case
                case "POLYGON":
                    break;
            }
        }
        frame.repaint();
    }


    //  Handles menuBar actions
    private class menuHandler implements ActionListener {

        @Override
        public void actionPerformed(ActionEvent event) {

            switch (event.getActionCommand()) {
                case "Open":
                    // stores the result of user actions
                    int result = fileChooser.showOpenDialog(null);
                    if (result == JFileChooser.CANCEL_OPTION) {
                        return;
                    }
                    String vecPath = fileChooser.getSelectedFile().getPath();
                    String vecName = fileChooser.getSelectedFile().getName();

                    if (!vecName.endsWith(".vec")) {
                        JOptionPane.showMessageDialog(null, "This is an invalid file type, " +
                                "please only use a .vec file", "Error", JOptionPane.WARNING_MESSAGE);
                        System.out.println("failed open");
                        break;
                    }

                    // call generateVec to load vec image to frame
                    else if (vecName.endsWith(".vec")) {

                        try {
                            drawingArea.clear();
                            drawingArea.shapeList.clear();
                            redoList.clear();
                            readVecFile.generateVec(vecPath);
                            arrayLocation = drawingArea.shapeList.size() - 1;
                        } catch (PaintException e) {
                            e.printStackTrace();
                        }
                    }

                    break;

                case "Save":
                    result = fileChooser.showSaveDialog(null);
                    File f = fileChooser.getSelectedFile();

                    String fileName = f.getAbsolutePath();

                    if (!fileName.endsWith(".vec")) {
                        f = new File(fileName + ".vec");
                    }

                    if (result == JFileChooser.CANCEL_OPTION) {
                        return;
                    }

                    if (result == JFileChooser.APPROVE_OPTION) {
                        try {
                            FileWriter fw = new FileWriter(f);

                            for (int i = 0; i < drawingArea.vecList.size(); i++) {
                                fw.write(drawingArea.vecList.get(i) + "\r\n");
                            }

                            fw.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            break;

                        }
                    }
                    break;

                case "Export to bmp":
                    int panelWidth = PaintApp.drawingarea.getWidth();
                    int panelHeight = PaintApp.drawingarea.getHeight();

                    BufferedImage drawing = new BufferedImage(panelWidth, panelHeight, BufferedImage.TYPE_INT_RGB);

                    Graphics2D savedFile = drawing.createGraphics();
                    PaintApp.drawingarea.paint(savedFile);
                    savedFile.dispose();

                    result = fileChooser.showSaveDialog(null);
                    File bmpName = fileChooser.getSelectedFile();

                    String bmpFileName = bmpName.getAbsolutePath();

                    if (!bmpFileName.endsWith(".bmp")) {
                        bmpName = new File(bmpFileName + ".bmp");
                    }
                    if (result == JFileChooser.CANCEL_OPTION) {
                        return;
                    }

                    if (result == JFileChooser.APPROVE_OPTION) {
                        try {
                            ImageIO.write(drawing, "bmp", bmpName);

                        } catch (Exception e) {
                            e.printStackTrace();
                            break;

                        }
                    }
                    break;

                case "Zoom +":
                    zoom(PaintApp.f, 0.25);

                    break;

                case "Zoom -":
                    zoom(PaintApp.f, -0.25);

                    break;

                case "Undo":
                    try {
                        System.out.println("The redo list is currently: " + arrayLocation + " long");

                        redoList.add(drawingArea.shapeList.get(drawingArea.shapeList.size() - 1));
                        drawingArea.shapeList.remove(drawingArea.shapeList.size() - 1);
                        arrayLocation -= 1;
                        PaintApp.f.repaint();

                        // FOR VEC SAVING ///////////////////////////////////
                        // undo colors after shape
                        undoColorVec();

                        // add shape to redo list
                        vecRedoList.add(drawingArea.vecList.get(drawingArea.vecList.size() - 1));

                        // remove last shape on vec
                        drawingArea.vecList.remove(drawingArea.vecList.size() - 1);

                        // undo colors before shape
                        undoColorVec();

                        // add last used colors back onto vec
                        redoColorVec();
                        //////////////////////////////////////////////////////

                        System.out.println("Something has been undone! the array is now: " + arrayLocation + " long");
                    } catch (Exception e) {
                        System.out.println("Nothing To Undo");
                        if (arrayLocation == -1) {
                            JOptionPane.showMessageDialog(null, "Nothing To Undo",
                                    "Error", JOptionPane.WARNING_MESSAGE);
                        }
                    }
                    break;


                case "Redo":
                    try {
                        System.out.println("The redo list is currently: " + arrayLocation + " long");
                        arrayLocation += 1;

                        drawingArea.shapeList.add(arrayLocation, redoList.get(redoList.size() - 1));
                        redoList.remove(redoList.get(redoList.size() - 1));

                        //FOR VEC SAVING
                        drawingArea.vecList.add(arrayLocation, vecRedoList.get(vecRedoList.size() - 1));
                        vecRedoList.remove(vecRedoList.get(vecRedoList.size() - 1));
                        System.out.print(vecRedoList);

                        PaintApp.f.repaint();

                        System.out.println("Something has been redone! the array is now: " + arrayLocation + " long");
                    } catch (Exception e) {
                        System.out.println("Nothing To Redo");
                        JOptionPane.showMessageDialog(null, "Nothing To Redo",
                                "Error", JOptionPane.WARNING_MESSAGE);
                        arrayLocation -= 1;
                        System.out.print(vecRedoList);
                    }
                    break;
            }
        }
    }
}

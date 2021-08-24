package vectorGui.vecLogic;

import vectorGui.PaintApp;
import vectorGui.PaintException;
import vectorGui.buttonsAndToolBars.colorPanel;
import vectorGui.buttonsAndToolBars.fillPanel;
import vectorGui.drawingLogic.drawingArea;


import java.awt.*;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.awt.geom.Path2D;
import java.awt.geom.Rectangle2D;
import java.io.*;
import java.util.NoSuchElementException;
import java.util.Scanner;

public class readVecFile {


    /**
     * @param fileDirectory pass directory of desired resource
     **/

    public static void generateVec(String fileDirectory) throws PaintException {

        File file = new File(fileDirectory);


        try {

            // reset colors to default
            fillPanel.setFill = fillPanel.clear;
            colorPanel.setColor = Color.BLACK;

            Scanner in = new Scanner(file);
            while (in.hasNext()) {
                String currentWord = in.next();
                System.out.println(currentWord);

                if (currentWord.startsWith("LINE")) {
                    double x1 = Double.parseDouble(in.next()); // must be in order
                    double y1 = Double.parseDouble(in.next()); //
                    double x2 = Double.parseDouble(in.next()); //
                    double y2 = Double.parseDouble(in.next()); //

                    Line2D scannedLine = new Line2D.Double(x1 * PaintApp.drawingarea.getWidth(), y1 * PaintApp.drawingarea.getHeight(),
                            x2 * PaintApp.drawingarea.getWidth(), y2 * PaintApp.drawingarea.getHeight());

                    drawingArea.addLine(scannedLine);
                    PaintApp.f.repaint();

                } else if (currentWord.startsWith("ELLIPSE")) {

                    double x = Double.parseDouble(in.next());
                    System.out.println(x);
                    double y = Double.parseDouble(in.next());
                    System.out.println(y);
                    double w = Double.parseDouble(in.next());
                    System.out.println(w);
                    double h = Double.parseDouble(in.next());
                    System.out.println(h);

                    // Manipulate ellipse to resolve garbage values
                    Ellipse2D scannedEllipse = new Ellipse2D.Double(x * PaintApp.drawingarea.getWidth(), y * PaintApp.drawingarea.getHeight(),
                            (w - x) * PaintApp.drawingarea.getWidth(), (h - y) * PaintApp.drawingarea.getHeight());

                    drawingArea.addEllipse(scannedEllipse);

                    PaintApp.f.repaint();

                } else if (currentWord.startsWith("RECTANGLE")) {

                    double x = Double.parseDouble(in.next());
                    System.out.println(x);
                    double y = Double.parseDouble(in.next());
                    System.out.println(y);
                    double w = Double.parseDouble(in.next());
                    System.out.println(w);
                    double h = Double.parseDouble(in.next());
                    System.out.println(h);

                    // Manipulate rectangle to resolve garbage values
                    Rectangle2D scannedRectangle = new Rectangle2D.Double(x * PaintApp.drawingarea.getWidth(), y * PaintApp.drawingarea.getHeight(),
                            (w - x) * PaintApp.drawingarea.getWidth(), (h - y) * PaintApp.drawingarea.getHeight());


                    drawingArea.addRectangle(scannedRectangle);
                    PaintApp.f.repaint();


                } else if (currentWord.startsWith("PLOT")) {

                    double x = Double.parseDouble(in.next());
                    double y = Double.parseDouble(in.next());

                    Ellipse2D scannedPlot = new Ellipse2D.Double(x * PaintApp.drawingarea.getWidth(), y * PaintApp.drawingarea.getHeight(),
                            2, 2);
                    drawingArea.addPlot(scannedPlot);

                    PaintApp.f.repaint();

                } else if (currentWord.startsWith("POLYGON")) {

                    Path2D scannedPolygon = new Path2D.Double();
                    double initialX = Double.parseDouble(in.next());
                    double initialY = Double.parseDouble(in.next());
                    scannedPolygon.moveTo(initialX * PaintApp.drawingarea.getWidth(), initialY * PaintApp.drawingarea.getHeight());
                    do {
                        double x = Double.parseDouble(in.next());
                        double y = Double.parseDouble(in.next());
                        scannedPolygon.lineTo(x * PaintApp.drawingarea.getWidth(), y * PaintApp.drawingarea.getHeight());
                    } while (in.hasNextDouble());
                    scannedPolygon.closePath();
                    drawingArea.addPolygon(scannedPolygon);
                    PaintApp.f.repaint();


                } else if (currentWord.startsWith("PEN")) {

                    Color penColor = Color.decode(in.next());
                    colorPanel.setColor = penColor;
                    drawingArea.vecList.add("PEN " + "#"+Integer.toHexString(colorPanel.setColor.getRGB()).substring(2).toUpperCase());
                }

                //FILL only fills the background - not shapes
                //Uncomment to see rectangles in Example3.vec
                else if (currentWord.startsWith("FILL")){

                    try {
                        Color bg = Color.decode(in.next());
                            fillPanel.setFill = bg;
                            drawingArea.vecList.add("FILL " + "#"+Integer.toHexString(fillPanel.setFill.getRGB()).substring(2).toUpperCase());
                    }
                    // catch block handles when FILL is OFF
                    catch (NumberFormatException e){
                        fillPanel.setFill = fillPanel.clear;
                        drawingArea.vecList.add("FILL OFF");
                        in.nextLine();
                    }

                }

                else {
                    // if nothing is handled, move on to next word
                    in.next();
                }

            }
            in.close();

        } catch (FileNotFoundException e) {
            System.out.println("File not found");
        } catch (NoSuchElementException e) {
            System.out.println("Elements exist and were not handled");
        } catch (PaintException e) {
            e.printStackTrace();
        }

    }

}


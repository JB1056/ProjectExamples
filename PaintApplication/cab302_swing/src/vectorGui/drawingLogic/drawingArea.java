package vectorGui.drawingLogic;

import vectorGui.PaintApp;
import vectorGui.PaintException;
import vectorGui.buttonsAndToolBars.colorPanel;
import vectorGui.buttonsAndToolBars.fillPanel;
import vectorGui.buttonsAndToolBars.toolBar;
import vectorGui.shapeClasses.ShapeClass;

import javax.swing.*;
import java.awt.*;
import java.awt.geom.*;
import java.text.DecimalFormat;
import java.util.ArrayList;
import static vectorGui.PaintApp.drawingarea;

public class drawingArea extends JPanel {
    public static ArrayList<ShapeClass> shapeList = new ArrayList<>();
    public static ArrayList<String> vecList = new ArrayList<>();
    public static Rectangle2D rectangle;
    public static Line2D line;
    public static Ellipse2D ellipse;
    public static Path2D polygon;
    public static DecimalFormat decimalLimiter = new DecimalFormat("#0.000000");

    public drawingArea() {
        // create drawing area
        setBackground(Color.WHITE);
        createShape ml = new createShape();
        addMouseListener(ml);
        addMouseMotionListener(ml);
    }

    @Override
    public Dimension getPreferredSize() {
        return isPreferredSizeSet() ?
                super.getPreferredSize() : new Dimension(PaintApp.SIZE, PaintApp.SIZE);
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);


        // paint rectangle array - multiplies co-ordinates by screen size to implement vector - sets pen and fill colours
        for (ShapeClass sl : shapeList) {
            switch (sl.getType()) {
                case "RECTANGLE":
                    Rectangle2D r = sl.getRectangle();
                    Graphics2D g2 = (Graphics2D) g;
                    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                    g2.setColor(sl.getFill());
                    g2.fill(new Rectangle2D.Double(r.getX() * drawingarea.getWidth(), r.getY() * drawingarea.getHeight(),
                            r.getWidth() * drawingarea.getWidth(), r.getHeight() * drawingarea.getHeight()));
                    g2.setColor(sl.getColor());
                    g2.draw(new Rectangle2D.Double(r.getX() * drawingarea.getWidth(), r.getY() * drawingarea.getHeight(),
                            r.getWidth() * drawingarea.getWidth(), r.getHeight() * drawingarea.getHeight()));
                    break;

                case "LINE":
                    g.setColor(sl.getColor());
                    Line2D l = sl.getLine();
                    g2 = (Graphics2D) g;
                    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                    g2.draw(new Line2D.Double(l.getX1() * drawingarea.getWidth(), l.getY1() * drawingarea.getHeight(),
                            l.getX2() * drawingarea.getWidth(), l.getY2() * drawingarea.getHeight()));
                    break;

                case "ELLIPSE":
                    Ellipse2D e = sl.getEllipse();
                    g2 = (Graphics2D) g;
                    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                    g2.setColor(sl.getFill());
                    g2.fill(new Ellipse2D.Double(e.getX() * drawingarea.getWidth(), e.getY() * drawingarea.getHeight(),
                            e.getWidth() * drawingarea.getWidth(), e.getHeight() * drawingarea.getHeight()));
                    g2.setColor(sl.getColor());
                    g2.draw(new Ellipse2D.Double(e.getX() * drawingarea.getWidth(), e.getY() * drawingarea.getHeight(),
                            e.getWidth() * drawingarea.getWidth(), e.getHeight() * drawingarea.getHeight()));
                    break;

                case "PLOT":
                    g.setColor(sl.getColor());
                    Ellipse2D p = sl.getEllipse();
                    g2 = (Graphics2D) g;
                    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                    g2.fill(new Ellipse2D.Double(p.getX() * drawingarea.getWidth(), p.getY() * drawingarea.getHeight(), 2, 2));
                    break;

                case "POLYGON":
                    // iterates through path array to change values to be vector
                    Path2D poly = sl.getPolygon();
                    float[] coords = new float[6];
                    PathIterator pathIterator = poly.getPathIterator(new AffineTransform());
                    Path2D newPolygon = new Path2D.Double();
                    while (!pathIterator.isDone()) {
                        switch (pathIterator.currentSegment(coords)) {
                            case PathIterator.SEG_MOVETO:
                                newPolygon.moveTo(coords[0] * drawingarea.getWidth(), coords[1] * drawingarea.getHeight());
                                break;
                            case PathIterator.SEG_LINETO:
                                newPolygon.lineTo(coords[0] * drawingarea.getWidth(), coords[1] * drawingarea.getHeight());
                                break;
                        }
                        pathIterator.next();
                    }
                    newPolygon.closePath();
                    g2 = (Graphics2D) g;
                    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                    g2.setColor(sl.getFill());
                    g2.fill(new Path2D.Double(newPolygon));
                    g2.setColor(sl.getColor());
                    g2.draw(new Path2D.Double(newPolygon));
                    break;
            }
        }

        //  Paint the line as the mouse is being dragged
        if (line != null | rectangle != null | ellipse != null | polygon != null) {
            Graphics2D g2d = (Graphics2D) g;
            if (rectangle != null) {
                g2d.draw(rectangle);
            }
            if (line != null) {
                g2d.draw(line);
            }
            if (ellipse != null) {
                g2d.draw(ellipse);
            }
            if (polygon != null) {
                g2d.draw(polygon);
                g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                g2d.draw(createShape.initialpoint);
            }
        }
    }

    // ADDING SHAPES TO ARRAY LIST - DIVIDES BY SCREEN SIZE TO IMPLEMENT VECTOR - ALSO ADDS TO VEC FILE FOR SAVING

    // Add rectangle to array
    public static void addRectangle(Rectangle2D rectangle) throws PaintException{
        //  Add the Rectangle to the List so it can be repainted
        rectangle.setRect(rectangle.getX() / drawingarea.getWidth(),rectangle.getY() / drawingarea.getHeight(),
                rectangle.getWidth() / drawingarea.getWidth(),rectangle.getHeight() / drawingarea.getHeight());
        ShapeClass cr = new ShapeClass(rectangle, ShapeClass.Type.RECTANGLE);
        shapeList.add(cr);
        vecList.add(cr.getType() + " " + decimalLimiter.format(cr.getRectangle().getX()) + " " + decimalLimiter.format(cr.getRectangle().getY())
                + " " + decimalLimiter.format(cr.getRectangle().getX() + cr.getRectangle().getWidth()) + " " + decimalLimiter.format(cr.getRectangle().getY() + cr.getRectangle().getHeight()));
        PaintApp.f.repaint();
        System.out.println("Added rectangle x: " + rectangle.getX() + ", y: " + rectangle.getY() + ", width: "
                + rectangle.getWidth() + ", height: " + rectangle.getHeight());
        toolBar.arrayLocation += 1;
    }

    // Add line to array
    public static void addLine(Line2D line) throws PaintException {
        //  Add the Line to the List so it can be repainted
        line.setLine(line.getX1() / drawingarea.getWidth(),line.getY1() / drawingarea.getHeight(),
                line.getX2() / drawingarea.getWidth(),line.getY2() / drawingarea.getHeight());
        ShapeClass cl = new ShapeClass(line, ShapeClass.Type.LINE);
        shapeList.add(cl);
        vecList.add(cl.getType() + " " + decimalLimiter.format(cl.getLine().getX1()) + " " + decimalLimiter.format(cl.getLine().getY1())
                + " " + decimalLimiter.format(cl.getLine().getX2()) + " " + decimalLimiter.format(cl.getLine().getY2()));
        PaintApp.f.repaint();
        System.out.println("Added line x1: " + line.getX1() + ", y1: " + line.getY1() + ", x2: "
                + line.getX2() + ", y2: " + line.getY2());
        toolBar.arrayLocation += 1;
    }

    // Add ellipse to array
    public static void addEllipse(Ellipse2D ellipse) throws PaintException {
        //  Add the Ellipse to the List so it can be repainted
        ellipse.setFrame(ellipse.getX() / drawingarea.getWidth(),ellipse.getY() / drawingarea.getHeight(),
                ellipse.getWidth() / drawingarea.getWidth(),ellipse.getHeight() / drawingarea.getHeight());
        ShapeClass ce = new ShapeClass(ellipse, ShapeClass.Type.ELLIPSE);
        shapeList.add(ce);
        vecList.add(ce.getType() + " " + decimalLimiter.format(ce.getEllipse().getX()) + " " + decimalLimiter.format(ce.getEllipse().getY())
                + " " + decimalLimiter.format(ce.getEllipse().getX() + ce.getEllipse().getWidth()) + " " + decimalLimiter.format(ce.getEllipse().getY() + ce.getEllipse().getHeight()));
        PaintApp.f.repaint();
        System.out.println("Added Ellipse x: " + ellipse.getX() + ", y: " + ellipse.getY() + ", width: "
                + ellipse.getWidth() + ", height: " + ellipse.getHeight());
        toolBar.arrayLocation += 1;
    }

    // Add ellipse to array
    public static void addPlot(Ellipse2D ellipse) throws PaintException {
        //  Add the Line to the List so it can be repainted
        ellipse.setFrame(ellipse.getX() / drawingarea.getWidth(),ellipse.getY() / drawingarea.getHeight(),
                ellipse.getWidth() / drawingarea.getWidth(),ellipse.getHeight() / drawingarea.getHeight());
        ShapeClass ce = new ShapeClass(ellipse, ShapeClass.Type.PLOT);
        shapeList.add(ce);
        vecList.add(ce.getType() + " " + decimalLimiter.format(ce.getEllipse().getX()) + " " + decimalLimiter.format(ce.getEllipse().getY()));
        PaintApp.f.repaint();
        System.out.println("Added Plot x: " + ellipse.getX() + ", y: " + ellipse.getY() + ", width: "
                + ellipse.getWidth() + ", height: " + ellipse.getHeight());
        toolBar.arrayLocation += 1;
    }

    // Add polygon to array
    // iterates through path array to change values and add to vec file for saving
    public static void addPolygon(Path2D polygon) throws PaintException {
        float[] coords = new float[6];
        PathIterator pathIterator = polygon.getPathIterator(new AffineTransform());
        Path2D newPolygon = new Path2D.Double();
        StringBuilder polyStr = new StringBuilder("POLYGON ");
        while (!pathIterator.isDone()) {
            switch (pathIterator.currentSegment(coords)) {
                case PathIterator.SEG_MOVETO:
                    newPolygon.moveTo(coords[0] / drawingarea.getWidth(), coords[1] / drawingarea.getHeight());
                    polyStr.append(decimalLimiter.format(coords[0] / drawingarea.getWidth()) + " " + decimalLimiter.format(coords[1] / drawingarea.getHeight()) + " ");
                    break;
                case PathIterator.SEG_LINETO:
                    newPolygon.lineTo(coords[0] / drawingarea.getWidth(), coords[1] / drawingarea.getHeight());
                    polyStr.append(decimalLimiter.format(coords[0] / drawingarea.getWidth()) + " " + decimalLimiter.format(coords[1] / drawingarea.getHeight()) + " ");
                    break;
            }
            pathIterator.next();
        }
        newPolygon.closePath();
        ShapeClass cp = new ShapeClass(newPolygon, ShapeClass.Type.POLYGON);
        shapeList.add(cp);
        vecList.add(polyStr.toString());
        System.out.println(polyStr);
        PaintApp.f.repaint();
        toolBar.arrayLocation += 1;
    }


    // clear function
    public static void clear() {
        // clears content and paints blank panel
        shapeList.clear();
        vecList.clear();
        fillPanel.setFill = fillPanel.clear;
        colorPanel.setColor = colorPanel.defaultpenColor;
        drawingarea.setBackground(Color.WHITE);
        PaintApp.f.repaint();
        System.out.println("The window has been cleared!");
        System.out.println("The redo list was: " + toolBar.arrayLocation +" long");
        toolBar.arrayLocation = shapeList.size() - 1;
        System.out.println("The screen has been cleared! The redo list is now: " + shapeList.size() +" long");

    }
}


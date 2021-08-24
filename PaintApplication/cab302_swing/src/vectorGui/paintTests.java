package vectorGui;

import vectorGui.buttonsAndToolBars.colorPanel;
import vectorGui.buttonsAndToolBars.fillPanel;
import vectorGui.shapeClasses.ShapeClass;

import java.awt.*;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.awt.geom.Rectangle2D;

import java.util.ArrayList;

import org.junit.jupiter.api.*;

import static org.junit.jupiter.api.Assertions.*;

public class paintTests {

    ShapeClass testShape;
    ArrayList<ShapeClass> shapeList = new ArrayList<ShapeClass>();


    Rectangle2D rectangle = new Rectangle2D.Double(0.842273,0.333182,0.867273,0.358182);
    Line2D line = new Line2D.Double(1,0.1,0.9,1);
    Ellipse2D ellipse = new Ellipse2D.Double(0.17, 0.17, 0.83, 0.83);


    // clear shape array before each test
    @BeforeEach
    public void setUpScore() {
        this.shapeList.clear();
    }


    // test ShapeClass
    @Test
    void ShapeClassConstructors() throws Exception {
        testShape = new ShapeClass(rectangle, ShapeClass.Type.RECTANGLE);
        testShape = new ShapeClass(line, ShapeClass.Type.LINE);
        testShape = new ShapeClass(ellipse, ShapeClass.Type.ELLIPSE);
        testShape = new ShapeClass(ellipse, ShapeClass.Type.PLOT);

        // Test shape constructor with wrong type
        assertThrows(PaintException.class, () -> {
            ShapeClass dumbRectangle = new ShapeClass(rectangle, ShapeClass.Type.ELLIPSE);
        },"Type must be RECTANGLE");

        assertThrows(PaintException.class, () -> {
            ShapeClass dumbEllipse = new ShapeClass(ellipse, ShapeClass.Type.LINE);
        },"Type must be ELLIPSE or PLOT");

        assertThrows(PaintException.class, () -> {
            ShapeClass dumbEllipse = new ShapeClass(line, ShapeClass.Type.PLOT);
        },"Type must be LINE");

    }


    @Test
    void getColor() throws PaintException {

        colorPanel.setColor = Color.LIGHT_GRAY;
        testShape = new ShapeClass(rectangle, ShapeClass.Type.RECTANGLE);
        assertEquals("java.awt.Color[r=192,g=192,b=192]", testShape.getColor().toString());

        colorPanel.setColor = Color.BLUE;
        testShape = new ShapeClass(line, ShapeClass.Type.LINE);
        assertEquals("java.awt.Color[r=0,g=0,b=255]", testShape.getColor().toString());

        colorPanel.setColor = Color.MAGENTA;
        testShape = new ShapeClass(ellipse, ShapeClass.Type.ELLIPSE);
        assertEquals("java.awt.Color[r=255,g=0,b=255]", testShape.getColor().toString());

        colorPanel.setColor = Color.CYAN;
        testShape = new ShapeClass(ellipse, ShapeClass.Type.PLOT);
        assertEquals("java.awt.Color[r=0,g=255,b=255]", testShape.getColor().toString());


    }

    @Test
    void getFill() throws PaintException {

        fillPanel.setFill = Color.GREEN;
        testShape = new ShapeClass(rectangle, ShapeClass.Type.RECTANGLE);
        assertEquals("java.awt.Color[r=0,g=255,b=0]", testShape.getFill().toString());


        fillPanel.setFill = Color.BLUE;
        testShape = new ShapeClass(line, ShapeClass.Type.LINE);
        assertEquals("java.awt.Color[r=0,g=0,b=255]", testShape.getFill().toString());


        fillPanel.setFill = Color.MAGENTA;
        testShape = new ShapeClass(ellipse, ShapeClass.Type.ELLIPSE);
        assertEquals("java.awt.Color[r=255,g=0,b=255]", testShape.getFill().toString());

        fillPanel.setFill = Color.YELLOW;
        testShape = new ShapeClass(ellipse, ShapeClass.Type.PLOT);
        assertEquals("java.awt.Color[r=255,g=255,b=0]", testShape.getFill().toString());


    }

    @Test
    void getType() throws PaintException {
        testShape = new ShapeClass(rectangle, ShapeClass.Type.RECTANGLE);
        assertEquals("RECTANGLE", testShape.getType());

        testShape = new ShapeClass(line, ShapeClass.Type.LINE);
        assertEquals("LINE", testShape.getType());

        testShape = new ShapeClass(ellipse, ShapeClass.Type.ELLIPSE);
        assertEquals("ELLIPSE", testShape.getType());

        testShape = new ShapeClass(ellipse, ShapeClass.Type.PLOT);
        assertEquals("PLOT", testShape.getType());


    }

    @Test
    void getRectangle() throws PaintException {

        testShape = new ShapeClass(rectangle, ShapeClass.Type.RECTANGLE);
        assertEquals(0.842273, testShape.getRectangle().getX());
        assertEquals(0.333182, testShape.getRectangle().getY());
        assertEquals(0.867273, testShape.getRectangle().getWidth());
        assertEquals(0.358182, testShape.getRectangle().getHeight());

        Rectangle2D bigRect = new Rectangle2D.Double(1.4398482, 4.382938933, 4.382938933, 6.33289484);
        ShapeClass largeRect = new ShapeClass(bigRect, ShapeClass.Type.RECTANGLE);
        assertEquals(1.4398482,largeRect.getRectangle().getX());
        assertEquals(4.382938933, largeRect.getRectangle().getY());
        assertEquals(4.382938933, largeRect.getRectangle().getWidth());
        assertEquals(6.33289484,largeRect.getRectangle().getHeight());
    }

    @Test
    void getLine() throws PaintException {

        testShape = new ShapeClass(line, ShapeClass.Type.LINE);
        assertEquals(1,testShape.getLine().getX1());
        assertEquals(0.1, testShape.getLine().getY1());
        assertEquals(0.9, testShape.getLine().getX2());
        assertEquals(1,testShape.getLine().getY2());

        Line2D bigLine = new Line2D.Double(1.3093019394, 2.30940032, 3.32030943, 4.50949303);
        ShapeClass longLine = new ShapeClass(bigLine, ShapeClass.Type.LINE);
        assertEquals(1.3093019394,longLine.getLine().getX1());
        assertEquals(2.30940032, longLine.getLine().getY1());
        assertEquals(3.32030943, longLine.getLine().getX2());
        assertEquals(4.50949303,longLine.getLine().getY2());
    }

    @Test
    void getEllipse() throws PaintException{
        Ellipse2D ellipse = new Ellipse2D.Double(0.17, 0.17, 0.83, 0.83);

        testShape = new ShapeClass(ellipse, ShapeClass.Type.ELLIPSE);
        assertEquals(0.17, testShape.getEllipse().getX());
        assertEquals(0.17, testShape.getEllipse().getY());
        assertEquals(0.83, testShape.getEllipse().getWidth());
        assertEquals(0.83, testShape.getEllipse().getHeight());

        Ellipse2D bigEllipse = new Ellipse2D.Double(0.24234314,1.34535439, 3, 4);
        ShapeClass garbageEllipse = new ShapeClass(bigEllipse, ShapeClass.Type.ELLIPSE);
        assertEquals(0.24234314, garbageEllipse.getEllipse().getX());
        assertEquals(1.34535439, garbageEllipse.getEllipse().getY());
        assertEquals(3, garbageEllipse.getEllipse().getWidth());
        assertEquals(4, garbageEllipse.getEllipse().getHeight());

    }


    // test toolbar
    @Test
    void buildToolBar() {



    }


    // test drawingArea
    @Test
    public void getPreferredSize() {

    }

    @Test
    public void paintComponent() {

    }

    @Test
    public void addRectangle() {
        Rectangle2D rec1 = new Rectangle2D.Double();
        Rectangle2D rec2 = new Rectangle2D.Double();
        Rectangle2D rec3 = new Rectangle2D.Double();
        Rectangle2D rec4 = new Rectangle2D.Double();

    }

    @Test
    public void addLine() {

    }

    @Test
    public void addEllipse() {

    }

    @Test
    public void addPlot() {

    }

    @Test
    public void clear() {

    }


    // test main
    @Test
    public void main() {

    }


}
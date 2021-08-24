package vectorGui.shapeClasses;

import vectorGui.PaintException;
import vectorGui.buttonsAndToolBars.colorPanel;
import vectorGui.buttonsAndToolBars.fillPanel;

import java.awt.*;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Path2D;
import java.awt.geom.Rectangle2D;
import java.awt.geom.Line2D;

public class ShapeClass
{
    private Color color;
    private Color fill;
    private Line2D line;
    private Rectangle2D rectangle;
    private Ellipse2D ellipse;
    private Path2D polygon;
    public enum Type{RECTANGLE, LINE, ELLIPSE, PLOT, POLYGON};
    private Type type;

    public ShapeClass(Rectangle2D rectangle, Type type) throws PaintException {
        color = colorPanel.setColor;
        fill = fillPanel.setFill;
        this.rectangle = rectangle;
        if (type != Type.RECTANGLE){
            throw new PaintException("Type must be RECTANGLE");
        }
        this.type = type;
    }

    public ShapeClass(Line2D line, Type type) throws PaintException {
        color = colorPanel.setColor;
        fill = fillPanel.setFill;
        this.line = line;
        if (type != Type.LINE){
            throw new PaintException("Type must be LINE");
        }
        else{
            this.type = type;
        }

    }

    public ShapeClass(Ellipse2D ellipse, Type type) throws PaintException {
        color = colorPanel.setColor;
        fill = fillPanel.setFill;
        this.ellipse = ellipse;
        if (type != Type.ELLIPSE && type != Type.PLOT){
            throw new PaintException("Type must be ELLIPSE or PLOT");
        }

        else {
            this.type = type;
        }

    }

    public ShapeClass(Path2D polygon, Type type) throws PaintException {
        color = colorPanel.setColor;
        fill = fillPanel.setFill;
        this.polygon = polygon;
        if (type != Type.POLYGON){
            throw new PaintException("Type must be POLYGON");
        }

        else {
            this.type = type;
        }

    }

    public Color getColor() {
        return color;
    }

    public Color getFill() {
        return fill;
    }

    public String getType(){
        return this.type.toString();
    }

    public Rectangle2D getRectangle() {
        return rectangle;
    }

    public Line2D getLine() {
        return line;
    }

    public Ellipse2D getEllipse() {
        return ellipse;
    }

    public Path2D getPolygon() {
        return polygon;
    }
}

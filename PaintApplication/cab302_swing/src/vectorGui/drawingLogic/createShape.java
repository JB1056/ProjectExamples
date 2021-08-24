package vectorGui.drawingLogic;

import vectorGui.PaintApp;
import vectorGui.PaintException;
import vectorGui.buttonsAndToolBars.buttonPanel;

import javax.swing.event.MouseInputAdapter;
import java.awt.*;
import java.awt.event.MouseEvent;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.awt.geom.Path2D;
import java.awt.geom.Rectangle2D;

public class createShape extends MouseInputAdapter {
    private Point startPoint;
    private boolean activeP = false;
    public static Ellipse2D initialpoint;

    public void mousePressed(MouseEvent e) {
        startPoint = e.getPoint();

        // initiate rectangle
        if (buttonPanel.shapeTool == "Rectangle" || buttonPanel.shapeTool == "FilledRectangle") {
            drawingArea.rectangle = new Rectangle2D.Double();
        }

        // initiate line
        else if (buttonPanel.shapeTool == "Line") {
            drawingArea.line = new Line2D.Double();
        }

        // initiate ellipse
        else if (buttonPanel.shapeTool == "Ellipse" || buttonPanel.shapeTool == "Plot") {
            drawingArea.ellipse = new Ellipse2D.Double();
        }

        // draw polygon
        else if (buttonPanel.shapeTool == "Polygon") {
            Point p = e.getPoint();
            if (e.getButton() == MouseEvent.BUTTON1) {
                if (!activeP) {
                    drawingArea.polygon = new Path2D.Double();
                    initialpoint = new Ellipse2D.Double();
                    initialpoint.setFrame(p.x - 2.5, p.y - 2.5, 5, 5);
                    drawingArea.polygon.moveTo(p.x, p.y);
                    activeP = true;
                } else {
                    drawingArea.polygon.lineTo(p.x, p.y);
                }
            }
            if (e.getButton() == MouseEvent.BUTTON3) {
                drawingArea.polygon.closePath();
                try {
                    drawingArea.addPolygon(drawingArea.polygon);
                    drawingArea.polygon = null;
                } catch (PaintException ex) {
                    ex.printStackTrace();
                }
                activeP = false;
            }

            PaintApp.f.repaint();
        }
    }

    public void mouseDragged(MouseEvent e) {
        // set rectangle size
        if (buttonPanel.shapeTool == "Rectangle") {
            int x = Math.min(startPoint.x, e.getX());
            int y = Math.min(startPoint.y, e.getY());
            int width = Math.abs(startPoint.x - e.getX());
            int height = Math.abs(startPoint.y - e.getY());

            drawingArea.rectangle.setRect(x, y, width, height);
            PaintApp.f.repaint();
        }

        // set line size
        else if (buttonPanel.shapeTool == "Line") {
            int x1 = startPoint.x;
            int y1 = startPoint.y;
            int x2 = e.getX();
            int y2 = e.getY();

            drawingArea.line.setLine(x1, y1, x2, y2);
            PaintApp.f.repaint();
        }

        // set ellipse size
        if (buttonPanel.shapeTool == "Ellipse") {
            int x = Math.min(startPoint.x, e.getX());
            int y = Math.min(startPoint.y, e.getY());
            int width = Math.abs(startPoint.x - e.getX());
            int height = Math.abs(startPoint.y - e.getY());

            drawingArea.ellipse.setFrame(x, y, width, height);
            PaintApp.f.repaint();
        }
    }

    public void mouseReleased(MouseEvent e) {

        // draw plot
        if (buttonPanel.shapeTool == "Plot") {

            int x = Math.min(startPoint.x, startPoint.x);
            int y = Math.min(startPoint.y, startPoint.y);
            int width = Math.abs(2);
            int height = Math.abs(2);

            drawingArea.ellipse.setFrame(x, y, width, height);
            PaintApp.f.repaint();

        }

        // adding rectangle to array
        if (buttonPanel.shapeTool == "Rectangle") {
            try {

                if (drawingArea.rectangle.getWidth() != 0 || drawingArea.rectangle.getHeight() != 0) {
                    drawingArea.addRectangle(drawingArea.rectangle);
                }
                drawingArea.rectangle = null;
            } catch (PaintException ex) {
                ex.printStackTrace();
            }

        }

        // adding line to array
        else if (buttonPanel.shapeTool == "Line") {
            try {
                drawingArea.addLine(drawingArea.line);
                drawingArea.line = null;
            } catch (PaintException ex) {
                ex.printStackTrace();
            }
        }

        // adding ellipse to array
        else if (buttonPanel.shapeTool == "Ellipse") {
            try {
                if (drawingArea.ellipse.getWidth() != 0 || drawingArea.ellipse.getHeight() != 0) {
                    drawingArea.addEllipse(drawingArea.ellipse);
                }
                drawingArea.ellipse = null;
            } catch (PaintException ex) {
                ex.printStackTrace();
            }
        }

        // adding plot to array
        else if (buttonPanel.shapeTool == "Plot") {
            try {
                if (drawingArea.ellipse.getWidth() != 0 || drawingArea.ellipse.getHeight() != 0) {
                    drawingArea.addPlot(drawingArea.ellipse);
                }
                drawingArea.ellipse = null;
            } catch (PaintException ex) {
                ex.printStackTrace();
            }
        }
    }
}
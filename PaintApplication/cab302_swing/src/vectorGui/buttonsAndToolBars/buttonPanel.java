package vectorGui.buttonsAndToolBars;

import vectorGui.PaintApp;
import vectorGui.drawingLogic.drawingArea;

import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.font.TextAttribute;
import java.awt.geom.Path2D;
import java.util.Map;

public class buttonPanel extends JPanel implements ActionListener
{
    public static String shapeTool = "Line";
    JButton polygonButton = new JButton();

    public buttonPanel() {
        add( createButton("Clear Screen", null) );
        add( createButton("Line", null) );
        add( createButton("Rectangle", null) );
        add( createButton("Ellipse", null) );
        polygonButton.setText("Polygon");
        polygonButton.setBackground(null);
        polygonButton.addActionListener(this);
        add (polygonButton);
        add( createButton("Plot", null) );
        add( createButton("Clear Fill", null) );
    }

    private JButton createButton(String text, Color background) {
        JButton button = new JButton( text );
        button.setBackground( background );
        button.addActionListener( this );
        return button;
    }

    public void actionPerformed(ActionEvent e) {

        if ("Clear Screen".equals(e.getActionCommand())) {
            PaintApp.drawingarea.clear();
            polygonButton.setText("Polygon");
        }
        else if ("Line".equals(e.getActionCommand())) {
            shapeTool = "Line";
            polygonButton.setText("Polygon");
        }
        else if ("Rectangle".equals(e.getActionCommand())) {
            shapeTool = "Rectangle";
            polygonButton.setText("Polygon");
        }
        else if ("Ellipse".equals(e.getActionCommand())) {
            shapeTool = "Ellipse";
            polygonButton.setText("Polygon");
        }
        else if ("Plot".equals(e.getActionCommand())) {
            shapeTool = "Plot";
            polygonButton.setText("Polygon");
        }
        else if ("Polygon".equals(e.getActionCommand())) {
            shapeTool = "Polygon";
            // sets button text to instruction for completing polygon shape / other buttons reset back to polygon
            polygonButton.setText("rmb finish");
        }
        else if ("Clear Fill".equals(e.getActionCommand())) {
            JButton button = (JButton)e.getSource();
            fillPanel.setFill = fillPanel.clear;
            drawingArea.vecList.add("FILL OFF");
            polygonButton.setText("Polygon");
        }
    }
}

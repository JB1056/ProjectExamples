package vectorGui.buttonsAndToolBars;

import vectorGui.drawingLogic.drawingArea;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import static vectorGui.buttonsAndToolBars.colourSelector.*;

public class fillPanel extends JPanel implements ActionListener
{
    public static Color clear = new Color (0, 0, 0, 0); // using hex code in #AARRGGBB format crashes java
    public static Color defaultFillColor = new Color (0, 0, 0, 0);
    public static Color setFill = defaultFillColor;


    public fillPanel()
    {
        JPanel p = new JPanel();
        p.setLayout(new BoxLayout(p, BoxLayout.Y_AXIS));
        JLabel fillLabel = new JLabel("Fill");
        JLabel spacer = new JLabel(" ");
        fillLabel.setFont(new Font("Verdana", 1, 10));
        spacer.setFont(new Font("Verdana", 1, 2));
        fillLabel.setAlignmentX(CENTER_ALIGNMENT);
        p.add (fillLabel);
        p.add (spacer);
        p.add( createButton("	", hexBlack) );
        p.add( createButton("	", hexDarkGray) );
        p.add( createButton("	", hexGray) );
        p.add( createButton("	", hexLightGray) );
        p.add( createButton("	", hexWhite) );
        p.add( createButton("	", hexPink) );
        p.add( createButton("	", hexRed) );
        p.add( createButton("	", hexMaroon) );
        p.add( createButton("	", hexMagenta) );
        p.add( createButton("	", hexPurple) );
        p.add( createButton("	", hexYellow) );
        p.add( createButton("	", hexGold) );
        p.add( createButton("	", hexOrange) );
        p.add( createButton("	", hexDirt) );
        p.add( createButton("	", hexBrown) );
        p.add( createButton("	", hexGreen) );
        p.add( createButton("	", hexLightGreen) );
        p.add( createButton("	", hexBlue) );
        p.add( createButton("	", hexCyan) );
        add(p);


    }

    private JButton createButton(String text, Color background)
    {
        JButton button = new JButton( text );
        button.setBackground( background );
        button.addActionListener( this );
        button.setAlignmentX(CENTER_ALIGNMENT);
        button.setOpaque(true);
        button.setBorderPainted(false);
        return button;
    }

    public void actionPerformed(ActionEvent e)
    {
        JButton button = (JButton)e.getSource();
        setFill = button.getBackground();

        // saves fill colour to vec file
        drawingArea.vecList.add("FILL " + "#"+Integer.toHexString(setFill.getRGB()).substring(2).toUpperCase());
    }
}


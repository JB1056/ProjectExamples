package vectorGui.buttonsAndToolBars;

import vectorGui.drawingLogic.drawingArea;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import static vectorGui.buttonsAndToolBars.colourSelector.*;

public class colorPanel extends JPanel implements ActionListener
{
    public static Color defaultpenColor = new Color (0, 0, 0);
    public static Color setColor = defaultpenColor;

    public colorPanel()
    {
        JPanel p = new JPanel();
        p.setLayout(new BoxLayout(p, BoxLayout.Y_AXIS));
        JLabel lineLabel = new JLabel("Line");
        JLabel spacer = new JLabel(" ");
        lineLabel.setFont(new Font("Verdana", 1, 10));
        spacer.setFont(new Font("Verdana", 1, 2));
        lineLabel.setAlignmentX(CENTER_ALIGNMENT);
        p.add (lineLabel);
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
        setColor = button.getBackground();

        // adds colour to vec file
        drawingArea.vecList.add("PEN " + "#"+Integer.toHexString(setColor.getRGB()).substring(2).toUpperCase());
    }
}

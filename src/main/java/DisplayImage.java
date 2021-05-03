import java.awt.FlowLayout;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;

public class DisplayImage {

    public static void displayImage(String path) throws IOException
    {
        BufferedImage img=ImageIO.read(new File(path));
        ImageIcon icon=new ImageIcon(img);
        JFrame frame=new JFrame();
        frame.setLayout(new FlowLayout());
//        frame.setSize(1698,754); // dokladne wymiary grafiki z wykresem
        frame.setSize(1750,800); // wymiary grafiki z wykresem z lekkim marginesem
        JLabel lbl=new JLabel();
        lbl.setIcon(icon);
        frame.add(lbl);
        frame.setVisible(true);
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE );
    }

    public static void displayPlots() throws IOException {
        String cphPlotPath = "output//cph_plot.jpg";
        String kmPlotPath = "output//KM_plot.jpg";
        displayImage(cphPlotPath);
        displayImage(kmPlotPath);
    }
}

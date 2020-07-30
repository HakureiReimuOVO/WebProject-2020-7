package servlet.service;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;

@WebServlet("/CodeService")
public class CodeServlet extends HttpServlet {
    private final int WIDTH = 120;
    private final int HEIGHT = 35;

    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doPost(req, resp);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        BufferedImage bufferedImage = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics image = bufferedImage.getGraphics();
        setBackGround(image);
        drawRandomLine(image);
        String random = drawRandomNum((Graphics2D) image, "nl");
        req.getSession().setAttribute("Code", random);
        resp.setContentType("image/jpeg");
        resp.setDateHeader("expires", -1);
        resp.setHeader("Cache-Control", "no-cache");
        resp.setHeader("Pragma", "no-cache");
        ImageIO.write(bufferedImage, "jpg", resp.getOutputStream());
    }

    private void setBackGround(Graphics image) {
        image.setColor(Color.WHITE);
        image.fillRect(0, 0, WIDTH, HEIGHT);
    }

    private void drawRandomLine(Graphics image) {
        image.setColor(Color.BLACK);
        for (int i = 0; i < 5; i++) {
            int x1 = new Random().nextInt(WIDTH);
            int y1 = new Random().nextInt(HEIGHT);
            int x2 = new Random().nextInt(WIDTH);
            int y2 = new Random().nextInt(HEIGHT);
            image.drawLine(x1, y1, x2, y2);
        }
    }

    private String drawRandomNum(Graphics2D image, String... createTypeFlag) {
        image.setColor(Color.BLACK);
        image.setFont(new Font("Times New Roman", Font.BOLD, 20));
        String baseNumLetter = "0123456789ABCDEFGHJKLMNOPQRSTUVWXYZ";
        String baseNum = "0123456789";
        String baseLetter = "ABCDEFGHJKLMNOPQRSTUVWXYZ";
        if (createTypeFlag.length > 0 && null != createTypeFlag[0]) {
            if (createTypeFlag[0].equals("nl")) {
                return createRandomChar(image, baseNumLetter);
            } else if (createTypeFlag[0].equals("n")) {
                return createRandomChar(image, baseNum);
            } else if (createTypeFlag[0].equals("l")) {
                return createRandomChar(image, baseLetter);
            }
        } else {
            return createRandomChar(image, baseNumLetter);
        }
        return "";
    }

    private String createRandomChar(Graphics2D image, String baseChar) {
        StringBuffer stringBuffer = new StringBuffer();
        int x = 5;
        String letter = "";
        for (int i = 0; i < 4; i++) {
            int degree = new Random().nextInt() % 30;
            letter = baseChar.charAt(new Random().nextInt(baseChar.length())) + "";
            stringBuffer.append(letter);
            image.rotate(degree * Math.PI / 180, x, 20);
            image.drawString(letter, x, 20);
            image.rotate(-degree * Math.PI / 180, x, 20);
            x += 30;
        }
        return stringBuffer.toString();
    }

}

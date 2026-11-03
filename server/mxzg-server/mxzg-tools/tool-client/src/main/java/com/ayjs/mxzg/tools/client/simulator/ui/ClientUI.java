package com.ayjs.mxzg.tools.client.simulator.ui;

import javax.swing.*;
import java.awt.*;

/**
 * 模拟客户端UI
 *
 * @author tangyangbo 2019/8/6 15:51
 */
public class ClientUI extends JFrame {

    private static ClientUI client = new ClientUI();

    /**
     * 屏幕的宽
     */
    public static final int SCREEN_WIDTH = (int) Toolkit.getDefaultToolkit()
            .getScreenSize().getWidth();
    /**
     * 用户屏幕的高
     */
    public static final int SCREEN_HEIGHT = (int) Toolkit.getDefaultToolkit()
            .getScreenSize().getHeight();


    public static final int WIDTH = 1000;
    public static final int HEIGHT = 700;

    private JTextArea result;
    private JTextArea input;

    private ParamJPanel paramJPanel;

    public static ClientUI getInstance() {
        return client;
    }

    public static void main(String[] args) {
        ClientUI client = getInstance();
        client.init();
    }

    public void init() {
        setTitle("模拟器客户端");
        //设置窗口大小与居中
        setBounds((SCREEN_WIDTH - WIDTH) / 2, (SCREEN_HEIGHT - HEIGHT - 60) / 2, WIDTH, HEIGHT);

        // 点击关闭按钮关闭程序
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        this.initComponent();
        this.setVisible(true);
    }

    public void initComponent() {
        JPanel panel = new JPanel();
        panel.setBounds(0, 0, 280, 200);

        GridBagConstraints constraints = new GridBagConstraints();
        constraints.weighty = 8;
        constraints.fill = GridBagConstraints.HORIZONTAL;

        GridBagLayout gridLayout = new GridBagLayout();
        panel.setLayout(gridLayout);

        paramJPanel = new ParamJPanel();
        add(panel, paramJPanel, constraints, 0, 1, 5, 3);

        this.add(panel);

        JPanel inputPanel = new JPanel();
        inputPanel.setBounds(0, 200, 280, 470);
        input = new JTextArea();

        JScrollPane inputScroll = new JScrollPane();
        inputScroll.setPreferredSize(new Dimension(279, 460));
        inputScroll.setViewportView(input);
        inputScroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_NEVER);

        inputPanel.add(inputScroll);
        this.add(inputPanel);


        JPanel resultPanel = new JPanel();
        resultPanel.setBounds(280, 0, 712, 670);

        result = new JTextArea();
        result.setLineWrap(true);
        JScrollPane resultScroll = new JScrollPane();
        resultScroll.setPreferredSize(new Dimension(702, 660));
        resultScroll.setViewportView(result);
        resultScroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        resultPanel.add(resultScroll);
        this.add(resultPanel);

        //占位
        this.add(new JPanel());
    }

    public void add(JPanel panel, Component c, GridBagConstraints constraints, int x, int y, int w, int h) {
        constraints.gridx = x;
        constraints.gridy = y;
        constraints.gridwidth = w;
        constraints.gridheight = h;
        constraints.anchor = GridBagConstraints.CENTER;
        panel.add(c, constraints);
    }

    public void addResultText(String text) {
        result.append(text);
        result.selectAll();
    }

    public String getInputText() {
        return input.getText();
    }

    public void setInputText(String text) {
        input.setText(text);
    }
}

package com.ayjs.mxzg.tools.client.simulator.ui;

import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.tools.client.client.ClientService;
import com.ayjs.mxzg.tools.client.client.base.ProtocolRegistry;
import com.ayjs.mxzg.tools.client.simulator.ServerDetail;
import com.ayjs.mxzg.tools.client.simulator.ServerInfoService;
import com.google.protobuf.Descriptors;
import com.google.protobuf.Message;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.net.InetAddress;
import java.util.Comparator;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

/**
 * 参数面板
 *
 * @author tangyangbo 2019/8/6 16:18
 */
@Slf4j
public class ParamJPanel extends JPanel {

    private GridBagConstraints constraints = new GridBagConstraints();
    private JTextField userIdInput;
    private JComboBox<String> protocolCombo;
    public JTextField hostInput;
    private String selectedStr = null;
    private JComboBox<String> serverCombo;
    private JTextField platformInput;

    private static final String SELECT_SPLIT = "-";
    private static String userId = "1001";
    private static String platform = "1";
    private static String host = "127.0.0.1:16888";
    @Getter
    private static ServerDetail serverDetail;


    public ParamJPanel() {
        this.setPreferredSize(new Dimension(280, 180));

        constraints.weighty = 8;
        constraints.fill = GridBagConstraints.HORIZONTAL;
        GridBagLayout gridLayout = new GridBagLayout();
        this.setLayout(gridLayout);

        JLabel serverLabel = new JLabel("server：", SwingConstants.RIGHT);
        serverCombo = new JComboBox<String>();
        serverCombo.setPreferredSize(new Dimension(100, 20));
        serverCombo.setMaximumRowCount(3);
        serverCombo.setEditable(true);
        add(serverLabel, 0, 1, 1, 1);
        add(serverCombo, 1, 1, 2, 1);


        JLabel openIdLabel = new JLabel("userId：", SwingConstants.RIGHT);
        userIdInput = new JTextField(userId, 14);
        JButton connectButton = new JButton("登陆");
        connectButton.addActionListener(new ConnectActionListener());

        add(openIdLabel, 0, 2, 1, 1);
        add(userIdInput, 1, 2, 1, 1);
        add(connectButton, 2, 2, 1, 1);

        JLabel platformLabel = new JLabel("platform：", SwingConstants.RIGHT);
        JButton createButton = new JButton("创号");
        createButton.addActionListener(new CreateActionListener());
        platformInput = new JTextField(platform, 14);
        add(platformLabel, 0, 3, 1, 1);
        add(platformInput, 1, 3, 1, 1);
        add(createButton, 2, 3, 1, 1);


//        JLabel hostLabel = new JLabel("host：", SwingConstants.RIGHT);
//        hostInput = new JTextField(host, 14);


//        add(hostLabel, 0, 4, 1, 1);
//        add(hostInput, 1, 4, 1, 1);
//        add(connectButton, 2, 4, 1, 1);

        JLabel plabel = new JLabel("protocol：", SwingConstants.RIGHT);
        protocolCombo = new JComboBox<>();
        protocolCombo.setPreferredSize(new Dimension(215, 20));
        protocolCombo.setMaximumRowCount(25);
        protocolCombo.setEditable(true);

        add(plabel, 0, 5, 1, 1);
        add(protocolCombo, 1, 5, 2, 1);

        JLabel title = new JLabel("参数：", SwingConstants.RIGHT);
        JButton send = new JButton("发送");

        send.addActionListener(new SendButtonActionListener());
        JPanel emptyPanel = new JPanel();
        emptyPanel.setPreferredSize(new Dimension(157, 0));

        add(title, 0, 6, 1, 1);
        add(emptyPanel, 1, 6, 1, 1);
        add(send, 2, 6, 1, 1);

        listServerInfo();
        listProtocol();
    }

    public void add(Component c, int x, int y, int w, int h) {
        constraints.gridx = x;
        constraints.gridy = y;
        constraints.gridwidth = w;
        constraints.gridheight = h;
        this.add(c, constraints);
    }

    /**
     * 填充server下拉框
     */
    public void listServerInfo() {
        Map<Integer, ServerDetail> serverMap = ServerInfoService.getInstance().getServerMap();
        serverMap.values().stream().forEach(serverInfo ->
                serverCombo.addItem(serverInfo.toString()));

        // 找到本机
        try {
            InetAddress addr = InetAddress.getLocalHost();
            String hostAddress = addr.getHostAddress();
            Optional<ServerDetail> hostServerInfo = serverMap.values().stream().filter(serverInfo1 -> hostAddress.equals(serverInfo1.getS_u())).findFirst();
            if (hostServerInfo.isPresent()) {
                serverDetail = hostServerInfo.get();
                serverCombo.setSelectedItem(serverDetail.toString());
            } else {
                serverDetail = serverMap.values().stream().findFirst().get();
                serverCombo.setSelectedItem(serverDetail.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        serverCombo.addItemListener(new ServerComboBoxListener());
    }

    private class ServerComboBoxListener implements ItemListener {

        @Override
        public void itemStateChanged(ItemEvent e) {
            if (e.getStateChange() != ItemEvent.SELECTED) {
                return;
            }
            selectedStr = e.getItem().toString();
            String[] serverInfoStr = selectedStr.split(SELECT_SPLIT);
            serverDetail = new ServerDetail();
            serverDetail.setSid(Integer.parseInt(serverInfoStr[0]));
            serverDetail.setS_name(serverInfoStr[1]);
            serverDetail.setS_u(serverInfoStr[2]);
            serverDetail.setS_p(Integer.parseInt(serverInfoStr[3]));

        }
    }

    public void listProtocol() {
        ProtocolRegistry.getReqProtocolMap().entrySet().stream().sorted(Comparator.comparingInt(Map.Entry::getKey))
                .forEach(entry -> protocolCombo
                        .addItem(entry.getKey() + SELECT_SPLIT + entry.getValue().getDescriptorForType().getName()));

        protocolCombo.addItemListener(new ComboBoxListener());

    }

    private class ComboBoxListener implements ItemListener {

        @Override
        public void itemStateChanged(ItemEvent e) {
            if (e.getStateChange() != ItemEvent.SELECTED) {
                return;
            }
            selectedStr = e.getItem().toString();
            fillUpInput();
        }
    }

    public static String generateOpenId(String openId, String pwd) {
        return openId + "###" + pwd;
    }


    public class CreateActionListener implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent arg0) {
            String userIdStr = userIdInput.getText();
            if (StringUtils.isBlank(userIdStr)) {
                log.error("userIdStr is null ");
                return;
            }
            String platformStr = platformInput.getText();
            if (StringUtils.isBlank(platformStr)) {
                log.error("platformStr is null ");
                return;
            }

            long userId = Long.parseLong(userIdStr);
            int platform = Integer.parseInt(platformStr);

            ClientService.getInstance().connect(serverDetail.getS_u(), serverDetail.getS_p(), userId, platform, serverDetail.getSid());

            ClientService.getInstance().login();
            ClientService.getInstance().createPlayer(userId, platform, serverDetail.getSid());
        }
    }

    public class ConnectActionListener implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            String userIdStr = userIdInput.getText();
            if (StringUtils.isBlank(userIdStr)) {
                log.error("userIdStr is null ");
                return;
            }
            String platformStr = platformInput.getText();
            if (StringUtils.isBlank(platformStr)) {
                log.error("platformStr is null ");
                return;
            }
            long userId = Long.parseLong(userIdStr);
            int platform = Integer.parseInt(platformStr);
            ClientService.getInstance().connect(serverDetail.getS_u(), serverDetail.getS_p(), userId, platform, serverDetail.getSid());
            ClientService.getInstance().login();
        }
    }

    public class SendButtonActionListener implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            String[] strs = selectedStr.split("-");
            int messageId = Integer.parseInt(strs[0].trim());

            String reqJsonStr = ClientUI.getInstance().getInputText();

            Message reqMessage = ProtocolRegistry.getReqMessage(messageId);

            if (Objects.nonNull(reqMessage)) {
                Message.Builder messageBuilder = reqMessage.newBuilderForType();
                MessageUtils.jsonToMessage(reqJsonStr, messageBuilder);
                ClientService.getInstance().writeAndFlush(messageId, messageBuilder.build());
            }
        }
    }

    /**
     * 根据类型转换成json
     *
     * @param message
     * @return
     */
    public String messageToJson(Message message) {
        StringBuilder json = new StringBuilder();
        json.append("{\n ");
        message.getDescriptorForType().getFields().forEach(fieldDescriptor -> {
            messageToJson(json, fieldDescriptor);
        });
        json.deleteCharAt(json.length() - 2);
        json.append("}");
        return json.toString();
    }

    public String messageToJson(StringBuilder json, Descriptors.FieldDescriptor fieldDescriptor) {
        json.append("\"");
        json.append(fieldDescriptor.getName());
        json.append("\":");
        if ("MESSAGE".equals(fieldDescriptor.getType().name())) {
            json.append("\n{\n");
            fieldDescriptor.getMessageType().getFields().forEach(fieldDescriptor1 -> {
                messageToJson(json, fieldDescriptor1);
            });
            json.deleteCharAt(json.length() - 2);
            json.append("}");
        } else {
            json.append("\"\"");
        }
        json.append(",");
        json.append("\n");
        return json.toString();
    }

    public void fillUpInput() {
        String[] strs = selectedStr.split(SELECT_SPLIT);
        int protocol = Integer.parseInt(strs[0]);
        Message selectMessage = ProtocolRegistry.getReqMessage(protocol);
        ClientUI.getInstance().setInputText(messageToJson(selectMessage));
    }
}

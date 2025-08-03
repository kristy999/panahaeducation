package pahanaedu.util;

/**
 *
 * @author krish
 */
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class MailUtil {
    public static void sendHtmlEmail(String to, String subject, String htmlBody) {
        final String from = "krishanabeywardhana99@gmail.com";
        final String password = "zwgqcwldfbakiatn"; // Use an App Password if 2FA is enabled on Gmail

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("HTML Email sent successfully to " + to);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
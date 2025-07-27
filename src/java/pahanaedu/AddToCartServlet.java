package pahanaedu;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.*;

public class AddToCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Parse parameters safely
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        String itemName = request.getParameter("item_name");
        double itemPrice = Double.parseDouble(request.getParameter("item_price"));

        // Quantity: get from request, default 1 if not present or invalid
        int quantity = 1;
        String qtyParam = request.getParameter("quantity");
        if (qtyParam != null) {
            try {
                quantity = Integer.parseInt(qtyParam);
                if (quantity < 1) quantity = 1; // minimum quantity = 1
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }

        HttpSession session = request.getSession();

        // Retrieve or create cart: List of Map<String,Object>
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        // Check if item already in cart — update quantity if yes
        boolean found = false;
        for (Map<String, Object> cartItem : cart) {
            if ((Integer) cartItem.get("item_id") == itemId) {
                int currentQty = (Integer) cartItem.get("quantity");
                cartItem.put("quantity", currentQty + quantity);
                found = true;
                break;
            }
        }

        // If not found, add new item map
        if (!found) {
            Map<String, Object> item = new HashMap<>();
            item.put("item_id", itemId);
            item.put("item_name", itemName);
            item.put("item_price", itemPrice);
            item.put("quantity", quantity);
            cart.add(item);
        }

        // Save updated cart back in session
        session.setAttribute("cart", cart);

        // Redirect user back to item listing or cart page
        response.sendRedirect("viewItems.jsp");  // or "createBill.jsp" if you prefer
    }
}

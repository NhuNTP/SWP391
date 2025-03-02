<%--
    Document   : ViewIntentoryItem
    Created on : Feb 23, 2025, 9:43:14 PM
    Author     : DELL-Laptop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Manage Inventory</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


    </head>

    <body>

        <nav class="navbar navbar-inverse">
            <div class="container-fluid">
                <div class="navbar-header">
                    <a class="navbar-brand" href="#">MANAGE INVENTORY</a>
                </div>

            </div>
        </nav>
        <div class="container body-content">
            <h2>MANAGE INVENTORY</h2>
            <p>
                <a href="ManageInventory/AddInventoryItem.jsp" class="btn btn-info" id="btnCreate">Add New</a>
            </p>
            <table class="table table-bordered"  method="post">
                <tr>
                    <th>STT</th>
                    <th> ID</th>
                    <th> Name</th>
                    <th> Type</th>
                    <th> Price</th>
                    <th> Quantity</th>
                    <th> Unit</th>
                    <th> Description</th>
                    <th> Item Image</th>


                </tr>
                <%
                    java.util.List<Model.Inventory> inventoryItemList = (java.util.List<Model.Inventory>) request.getAttribute("InventoryItemList");
                    if (inventoryItemList != null && !inventoryItemList.isEmpty()) {
                        int displayIndex = 1;
                        for (Model.Inventory listItem : inventoryItemList) {
                %>
                <tr>
                    <Td valign="middle"><% out.print(displayIndex++); %></td>
                    <Td valign="middle"><% out.print(listItem.getItemId()); %></td>
                    <Td valign="middle"><% out.print(listItem.getItemName()); %></td>
                    <Td valign="middle"><% out.print(listItem.getItemType()); %></td>
                    <Td valign="middle"><% out.print(listItem.getItemPrice()); %></td>
                    <Td valign="middle"><% out.print(listItem.getItemQuantity()); %></td>
                    <Td valign="middle"><% out.print(listItem.getItemUnit()); %></td>
                    <Td valign="middle"><% out.print(listItem.getItemDescription()); %></td>
                    <Td valign="middle">
                        <%
                            String imagePath = listItem.getItemImage();
                            if (imagePath != null && !imagePath.isEmpty()) {
                        %>
                        <img src="<%= imagePath%>" alt="<%= listItem.getItemName()%>" style="max-width: 100px; max-height: 100px;">
                        <%
                            } else {
                                out.print("No Image"); // Hoặc hiển thị một hình ảnh placeholder nếu muốn
                            }
                        %>
                    </td>


                    <Td valign="middle">


                        <form action="ManageInventory/UpdateInventoryItem.jsp" method="post" style="display:inline;"> <%-- Sửa lại action ở đây --%>
                            <input type="hidden" name="itemId" value="<% out.print(listItem.getItemId()); %>">
                            <input type="hidden" name="itemName" value="<% out.print(listItem.getItemName()); %>">
                            <input type="hidden" name="itemType" value="<% out.print(listItem.getItemType()); %>">
                            <input type="hidden" name="itemPrice" value="<% out.print(listItem.getItemPrice()); %>">
                            <input type="hidden" name="itemQuantity" value="<% out.print(listItem.getItemQuantity()); %>">
                            <input type="hidden" name="itemUnit" value="<% out.print(listItem.getItemUnit()); %>">
                            <input type="hidden" name="itemDescription" value="<% out.print(listItem.getItemDescription());%>">
                            <input type="hidden" name="itemImage" value="<%= listItem.getItemImage() != null ? listItem.getItemImage() : ""%>"> <%-- QUAN TRỌNG: Phải có input itemImage --%>

                            <button type="submit" class="btn btn-warning">Update</button>
                        </form>
                        <form action="ManageCoupon/DeleteCoupon.jsp" method="post" style="display:inline;">
                            <input type="hidden" name="couponId" value="<% out.print(listItem.getItemId()); %>">
                            <%-- The following inputs are related to coupon from the original JSTL page, adjust them to InventoryItem properties if needed --%>
                            <input type="hidden" name="discountAmount" value="<% out.print(listItem.getItemPrice()); %>"> <%-- Example: Using ItemPrice as a placeholder --%>
                            <input type="hidden" name="expirationDate" value="<% out.print("N/A"); %>"> <%-- Example: No expiration date for inventory item --%>
                            <input type="hidden" name="isUsed" value="<% out.print("false"); %>"> <%-- Example:  Not applicable for inventory item --%>
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </td>
                </tr>

                <%
                    } // end for loop
                } else {
                %>
                <tr>
                    <td colspan="8">No inventory items available.</td>
                </tr>
                <%
                    } // end if inventoryItemList not null and not empty
                %>


            </table>
        </div>

    </body>
</html>
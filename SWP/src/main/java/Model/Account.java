/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author ADMIN
 */
public class Account {

    private int UserId;
    private String UserEmail;
    private String UserPassword;
    private String UserName;
    private String UserRole;
    private String IdentityCard;
    private String UserAddress;
    private String UserImage;

    public Account() {
    }

    public Account(int UserId, String UserEmail, String UserPassword, String UserName, String UserRole, String IdentityCard, String UserAddress, String UserImage) {
        this.UserId = UserId;
        this.UserEmail = UserEmail;
        this.UserPassword = UserPassword;
        this.UserName = UserName;
        this.UserRole = UserRole;
        this.IdentityCard = IdentityCard;
        this.UserAddress = UserAddress;
        this.UserImage = UserImage;
    }

    public Account(String UserEmail, String UserPassword, String UserName, String UserRole, String IdentityCard, String UserAddress, String UserImage) {
        this.UserEmail = UserEmail;
        this.UserPassword = UserPassword;
        this.UserName = UserName;
        this.UserRole = UserRole;
        this.IdentityCard = IdentityCard;
        this.UserAddress = UserAddress;
        this.UserImage = UserImage;
    }

    public int getUserId() {
        return UserId;
    }

    public void setUserId(int UserId) {
        this.UserId = UserId;
    }

    public String getUserEmail() {
        return UserEmail;
    }

    public void setUserEmail(String UserEmail) {
        this.UserEmail = UserEmail;
    }

    public String getUserPassword() {
        return UserPassword;
    }

    public void setUserPassword(String UserPassword) {
        this.UserPassword = UserPassword;
    }

    public String getUserName() {
        return UserName;
    }

    public void setUserName(String UserName) {
        this.UserName = UserName;
    }

    public String getUserRole() {
        return UserRole;
    }

    public void setUserRole(String UserRole) {
        this.UserRole = UserRole;
    }

    public String getIdentityCard() {
        return IdentityCard;
    }

    public void setIdentityCard(String IdentityCard) {
        this.IdentityCard = IdentityCard;
    }

    public String getUserAddress() {
        return UserAddress;
    }

    public void setUserAddress(String UserAddress) {
        this.UserAddress = UserAddress;
    }

    public String getUserImage() {
        return UserImage;
    }

    public void setUserImage(String UserImage) {
        this.UserImage = UserImage;
    }


}

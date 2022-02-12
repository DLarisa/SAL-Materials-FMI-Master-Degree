package lab5.ex.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.ToString;

// Ca să nu tb să generăm mereu funcțiile, mai ales dacă avem clase simpluțe, putem folosi Lombok
@Data // getteri și setteri
@AllArgsConstructor
@ToString
@Builder // să poți construi useri doar din anumite proprietăți, nu din toate (altfel tb definit constructor pt toate combinațiile posibile de parametrii)
public class User {
    private int id;
    private String userName;
    private String firstName;
    private String lastName;
    private String email;
    private String address;
    private String contact;

//    public User(int id, String userName, String firstName, String lastName, String email, String address, String contact) {
//        this.id = id;
//        this.userName = userName;
//        this.firstName = firstName;
//        this.lastName = lastName;
//        this.email = email;
//        this.address = address;
//        this.contact = contact;
//    }
//
//    public int getId() {
//        return id;
//    }
//
//    public void setId(int id) {
//        this.id = id;
//    }
//
//    public String getUserName() {
//        return userName;
//    }
//
//    public void setUserName(String userName) {
//        this.userName = userName;
//    }
//
//    public String getFirstName() {
//        return firstName;
//    }
//
//    public void setFirstName(String firstName) {
//        this.firstName = firstName;
//    }
//
//    public String getLastName() {
//        return lastName;
//    }
//
//    public void setLastName(String lastName) {
//        this.lastName = lastName;
//    }
//
//    public String getEmail() {
//        return email;
//    }
//
//    public void setEmail(String email) {
//        this.email = email;
//    }
//
//    public String getAddress() {
//        return address;
//    }
//
//    public void setAddress(String address) {
//        this.address = address;
//    }
//
//    public String getContact() {
//        return contact;
//    }
//
//    public void setContact(String contact) {
//        this.contact = contact;
//    }
//
//    @Override
//    public String toString() {
//        return "User{" +
//                "id=" + id +
//                ", userName='" + userName + '\'' +
//                ", firstName='" + firstName + '\'' +
//                ", lastName='" + lastName + '\'' +
//                ", email='" + email + '\'' +
//                ", address='" + address + '\'' +
//                ", contact='" + contact + '\'' +
//                '}';
//    }
}

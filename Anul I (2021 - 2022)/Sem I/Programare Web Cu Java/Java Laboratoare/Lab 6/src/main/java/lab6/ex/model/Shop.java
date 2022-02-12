package lab6.ex.model;

import java.util.List;

public class Shop {
    private int id;
    private String name;
    private String location;
    private List<Product> productList;

    public Shop(int id, String name, String location, List<Product> productList) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.productList = productList;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public List<Product> getProductList() {
        return productList;
    }

    public void setProductList(List<Product> productList) {
        this.productList = productList;
    }

    @Override
    public String toString() {
        return "Shop{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", location='" + location + '\'' +
                ", productList=" + productList +
                '}';
    }
}

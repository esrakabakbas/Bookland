package com.bookland.demobookland.controller;

import com.bookland.demobookland.model.Campaign;
import com.bookland.demobookland.model.projections.CustomerInfoProjection;
import com.bookland.demobookland.model.projections.OrderAdminSimpleProjection;
import com.bookland.demobookland.model.projections.OrderDetailAdminProjection;
import com.bookland.demobookland.model.projections.UserSearchProjection;
import com.bookland.demobookland.services.AdminServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
public class AdminController {

    @Autowired
    private AdminServices adminServices;

    @GetMapping(value = "/getAdmin", produces = MediaType.APPLICATION_JSON_VALUE)
    public CustomerInfoProjection getAdmin() {
        return adminServices.getAdmin();
    }

    @GetMapping(value = "/getCustomerDetails/{customerId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public CustomerInfoProjection getCustomerDetails(@PathVariable Integer customerId) {
        return adminServices.getCustomerDetails(customerId);
    }

    @GetMapping(value = "/manageCustomers/{pageNo}/{pageSize}", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<CustomerInfoProjection> getCustomers(@PathVariable Integer pageNo, @PathVariable Integer pageSize) {
        return adminServices.manageCustomers(pageNo - 1, pageSize);
    }

    @GetMapping(value = "/getCustomerCount", produces = MediaType.APPLICATION_JSON_VALUE)
    public Long getCustomerCount() {
        return adminServices.getCustomerCount();
    }

    @PutMapping(value = "/deActivateAccount/{customerId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public String deactivateAccount(@PathVariable Integer customerId) {
        return adminServices.deActivateAccount(customerId);
    }

    @PutMapping(value = "/activateAccount/{customerId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public String activateAccount(@PathVariable Integer customerId) {
        return adminServices.activateAccount(customerId);
    }

    @PostMapping(value = "/addCampaign", produces = MediaType.APPLICATION_JSON_VALUE)
    public String addCampaign(@Valid @RequestBody Campaign campaign) {
        return adminServices.addCampaign(campaign);
    }


    /*Get a specific order of details*/
    @GetMapping(value = "/showDetailOrderAdmin/{orderId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public OrderDetailAdminProjection showDetailOrderAdmin(@PathVariable Integer orderId) {
        return adminServices.showDetailOrderAdmin(orderId);
    }

    /*Taking all orders*/
    @GetMapping(value = "/showAllOrdersAdmin/{pageNo}/{pageSize}", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<OrderAdminSimpleProjection> showAllOrdersAdmin(@PathVariable Integer pageNo, @PathVariable Integer pageSize) {
        return adminServices.showAllOrdersAdmin(pageNo - 1, pageSize);
    }

    @GetMapping(value = "/getOrderCountTotal", produces = MediaType.APPLICATION_JSON_VALUE)
    public Long getOrderCountTotal() {
        return adminServices.getOrderCountTotal();
    }

    @GetMapping(value = "/confirmOrder/{orderId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Integer confirmOrder(@PathVariable Integer orderId) {
        return adminServices.confirmOrder(orderId);
    }

    @GetMapping(value = "/rejectOrder/{orderId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Integer rejectOrder(@PathVariable Integer orderId) {
        return adminServices.rejectOrder(orderId);
    }

    @GetMapping(value = "/searchCustomer/{pageNo}/{pageSize}", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<UserSearchProjection> getCustomerBySearchCriteria(@PathVariable Integer pageNo, @PathVariable Integer pageSize, String keyword) {
        return adminServices.getCustomerBySearchCriteria(pageNo - 1, pageSize, keyword);
    }

    @GetMapping(value = "/searchCountCustomer", produces = MediaType.APPLICATION_JSON_VALUE)
    public Long getCustomerCountBySearchCriteria(String keyword) {
        return adminServices.getCustomerCountBySearchCriteria(keyword);
    }
}




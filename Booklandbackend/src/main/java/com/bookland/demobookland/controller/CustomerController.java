package com.bookland.demobookland.controller;


import com.bookland.demobookland.model.Comment;
import com.bookland.demobookland.model.Customer;
import com.bookland.demobookland.model.projections.LoginInterface;
import com.bookland.demobookland.model.projections.WishListProjection;
import com.bookland.demobookland.model.validationGroups.LoginGroup;
import com.bookland.demobookland.model.validationGroups.SignUpGroup;
import com.bookland.demobookland.services.CustomerServices;
import com.bookland.demobookland.services.WishListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.security.auth.login.LoginException;
import java.util.List;

@RestController
public class CustomerController {

    @Autowired
    private CustomerServices customerServices;

    @Autowired
    private WishListService wishListService;

    @PostMapping(value = "/saveCustomer")
    public Integer saveCustomer(@Validated(SignUpGroup.class) @RequestBody Customer customer) {
        return customerServices.saveCustomer(customer);
    }

    @PostMapping(value = "/login")
    public LoginInterface getLogin(@Validated(LoginGroup.class) @RequestBody Customer customer) throws LoginException {
        return customerServices.getLogin(customer);
    }

    @PostMapping(value = "/makeComment/{bookId}/{customerId}")
    public Comment comment(@PathVariable Integer bookId, @PathVariable Integer customerId, @RequestBody Comment comment) {
        return customerServices.comment(bookId, customerId, comment);
    }

    @PostMapping(value = "/updateCustomer/{customerId}")
    public Customer updateCustomer(@PathVariable Integer customerId, @RequestBody Customer customer) throws LoginException {
        return customerServices.updateCustomer(customer, customerId);
    }

    @GetMapping(value = "/addFromWishList/{customerId}/{ISBN}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Integer addWishList(@PathVariable Integer customerId, @PathVariable Integer ISBN) {
        return customerServices.addWishList(customerId, ISBN);
    }

    @GetMapping(value = "/removeFromWishList/{customerId}/{ISBN}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Integer removeWishList(@PathVariable Integer customerId, @PathVariable Integer ISBN) {
        return customerServices.removeWishList(customerId, ISBN);
    }

    @GetMapping(value = "/myWishList/{pageNo}/{pageSize}/{customerId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<WishListProjection> myWishList(@PathVariable Integer pageNo, @PathVariable Integer pageSize, @PathVariable Integer customerId) {
        return wishListService.myWishList(pageNo - 1, pageSize, customerId);
    }

    @GetMapping(value = "/myWishListCount/{customerId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Long myWishListCount(@PathVariable Integer customerId) {
        return wishListService.myWishListCount(customerId);
    }
}

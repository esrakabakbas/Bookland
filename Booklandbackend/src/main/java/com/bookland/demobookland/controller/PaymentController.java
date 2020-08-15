package com.bookland.demobookland.controller;

import com.bookland.demobookland.model.OrderCreateDao;
import com.bookland.demobookland.model.ShippingCompany;
import com.bookland.demobookland.model.validationGroups.OrderCreation;
import com.bookland.demobookland.services.PaymentServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
public class PaymentController {
    @Autowired
    private PaymentServices paymentServices;


    /*-2--> invalid payment information
     * -1--> not enough budget
     * 1--> payment successful*/
    @PostMapping(value = "/createOrder/{customerId}/{addressId}/{shippingId}", produces = MediaType.APPLICATION_JSON_VALUE)
    public Integer orderCreation(@Validated(OrderCreation.class) @RequestBody OrderCreateDao orderInfo,
                                 @PathVariable Integer customerId, @PathVariable Integer addressId,
                                 @PathVariable Integer shippingId) {
        Integer result = paymentServices.saveMyCard(orderInfo.getCardNo(), orderInfo.getCardOwner(), customerId, orderInfo.getTotalAmount());
        if (result != 1) {
            return result;
        }

        return paymentServices.orderCreate(orderInfo.getBasketInfo(), orderInfo.getTotalAmount(),
                customerId, addressId, shippingId, orderInfo.getCardNo(), orderInfo.getCouponCode());
    }

    @GetMapping(value = "/getCompanies", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<ShippingCompany> getLastReleased() {
        return paymentServices.getCompanies();
    }

    @PostMapping(value = "/couponCheck", produces = MediaType.APPLICATION_JSON_VALUE)
    public Double applyCoupon(@RequestBody Map<String, Float> couponCode) {
        return paymentServices.applyCoupon(couponCode);
    }
}

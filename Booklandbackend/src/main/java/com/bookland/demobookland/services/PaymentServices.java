package com.bookland.demobookland.services;

import com.bookland.demobookland.model.*;
import com.bookland.demobookland.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class PaymentServices {
    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private ShippingCompanyRepository shippingCompanyRepository;

    @Autowired
    private PurchaseDetailRepository purchaseDetailRepository;

    @Autowired
    private CampaignRepository campaignRepository;

    @Autowired
    private ContainsRepository containsRepository;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Transactional
    public Integer saveMyCard(String cardNo, String cardOwner, Integer customerId, Float amount) {
        Customer customer = customerRepository.findByCustomerId(customerId);

        Card cardExist = paymentRepository.findByCardNo(cardNo);
        String name;
        String surname;
        try {
            String[] cardDetails = cardOwner.split("\\s+");
            name = cardDetails[0];
            surname = cardDetails[1];
        } catch (Exception e) {
            name = cardOwner;
            surname = cardOwner;
        }

        if (cardExist != null) {
            if (!name.equals(cardExist.getOwnerName()) || !surname.equals(cardExist.getOwnerSurname()))
                return -2;/*Invalid payment information*/
            if (!customer.getCustomerCardList().contains(cardExist)) {
                customer.getCustomerCardList().add(cardExist);
            }
            if (cardExist.getCardBudget() >= amount)
                return 1;/*Successful payment*/
            return -1;/*Not enough card limit*/
        }
        Card card = new Card();
        card.setCardNo(cardNo);
        card.setOwnerName(name);
        card.setOwnerSurname(surname);

        cardExist = paymentRepository.save(card);
        customer.getCustomerCardList().add(cardExist);
        cardExist.getCustomerCardList().add(customer);

        if (cardExist.getCardBudget() >= amount)
            return 1;/*Successful payment*/
        return -1;/*Not enough card limit*/
    }

    @Transactional
    public Integer cargoCreation(Integer shippingId) {
        PurchasedDetailedInfo purchasedDetailedInfo = new PurchasedDetailedInfo();
        purchasedDetailedInfo.setShippingCompanyId(shippingId);
        purchasedDetailedInfo.setReleasedTime(null);
        purchaseDetailRepository.save(purchasedDetailedInfo);
        return purchasedDetailedInfo.getTrackingNumber();
    }


    public List<ShippingCompany> getCompanies() {
        return shippingCompanyRepository.findAll();
    }

    @Transactional
    public Integer orderCreate(String basketInfo, Float totalAmount, Integer customerId,
                               Integer addressId, Integer shippingId, String cardNo, String coupon) {
        List<Integer> bookIds = new ArrayList<>();
        List<Integer> quantities = new ArrayList<>();

        Campaign campaign = campaignRepository.findByCouponCode(coupon);

        String[] basket = basketInfo.split(",");
        for (int i = 0; i < basket.length; i++) {
            if (i % 2 == 0)
                bookIds.add(Integer.valueOf(basket[i]));
            else
                quantities.add(Integer.valueOf(basket[i]));
        }

        Order currentOrder = new Order();
        if (campaign != null) {
            currentOrder.setCampaignId(campaign.getCampaignId());
            campaign.setParticipantQuantity(campaign.getParticipantQuantity() - 1);
        }
        currentOrder.setAddressId(addressId);
        currentOrder.setCustomerId(customerId);
        currentOrder.setTotalAmount(totalAmount);
        currentOrder.setOrderedTime(new Date());
        currentOrder.setCardNo(cardNo);
        orderRepository.save(currentOrder);

        for (int i = 0; i < bookIds.size(); i++) {
            Contains contains = new Contains();
            contains.setIsbn(bookIds.get(i));
            contains.setOrderId(currentOrder.getOrderId());
            contains.setQuantity(quantities.get(i));
            contains.setStatus(1);
            contains.setTrackingNumber(cargoCreation(shippingId));
            containsRepository.save(contains);
        }

        Card card = paymentRepository.findByCardNo(cardNo);
        card.setCardBudget(card.getCardBudget() - totalAmount);
        paymentRepository.save(card);
        return 1;
    }

    public double applyCoupon(Map<String, Float> couponCode) {
        Date today = new Date();

        double totalAmount = 0.0;
        String promoCode = null;

        for (String s : couponCode.keySet()) {
            promoCode = s;
            totalAmount = couponCode.get(s);
        }

        Campaign campaign = campaignRepository.findByCouponCode(promoCode);
        if (campaign != null && campaign.getParticipantQuantity() > 0
                && campaign.getEndDate().compareTo(today) > 0
                && (totalAmount * campaign.getCouponDiscount()) / 100 > 0) {
            return (float) totalAmount - ((totalAmount * campaign.getCouponDiscount()) / 100);
        }
        return (float) 0 /*it means coupon code is invalid*/;
    }
}

var ProductSelectorPlugin = {
  postRecalculateZCharge : function(previousZCharge,
    currentZCharge, chargeGroup, quote, allChargeGroups) {
    console.log('Charge Updated: ', currentZCharge['NAME']);
    // Validate updated charge discount
    if (currentZCharge['DISCOUNT'] >= 60){
      window.alert('Discount can\'t be greater than 60%');
      currentZCharge['DISCOUNT'] = previousZCharge['DISCOUNT'];
      zquGlobalPlugin.updateZCharge(currentZCharge);
    }
    asyncGetPrice(function(result) {
      // All recurring charges should have the same discount
      if (currentZCharge['CHARGE_TYPE'] === 'Recurring'){
        currentZCharge['DISCOUNT'] = result.recurring_discount.toString();
      }
      else if (currentZCharge['CHARGE_TYPE'] === 'One Time'){
        currentZcharge['DISCOUNT'] = result.one_time_discount.toString();
      }
      else if (currentZCharge['CHARGE_TYPE'] === 'Usage'){
        currentZCharge['DISCOUNT'] = result.usage_discount.toString();
      }
      zquGlobalPlugin.updateZCharge(currentZCharge);
    });
  }
};
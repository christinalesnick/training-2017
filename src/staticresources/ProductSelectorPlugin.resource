var ProductSelectorPlugin = {
    postRecalculateZCharge : function(previousZCharge,
      currentZCharge, chargeGroup, quote, allChargeGroups) {
      console.log('Charge Updated: ', currentZCharge['NAME']);
      asyncGetPrice(function(result) {
        console.log('Received info:');
        console.log(result);
        currentZCharge['DISCOUNT'] = result.discount.toString();
        zquGlobalPlugin.updateZCharge(currentZCharge);
      });
    }
};
global with sharing class RulesCustomAction implements zqu.CustomActionPlugin{
  global void perform(zqu.DataObject masterObject,
      Map < String, Object > attributes, String[] logs){

    Decimal chargeEffectivePrice = 1000;
    Decimal tierDiscount = 15;

    // Read values from Quote Object
    String quoteId = (String)masterObject.get('Id');
    logs.add('Quote Id: ' + quoteId);

    // Read values set in Rule Configuration
    String attributesParams = (String)attributes.get('msg');
    logs.add('Attributes passed into Rule: ' + attributesParams);

    // Get Quote Rate Plan data
    List < zqu.DataObject > plans =
        masterObject.getChildren('zqu__QuoteRatePlan__c');
    logs.add('# Rate Plans: ' + plans.size() );

    // Get Quote Rate Plan Charge data
    List < zqu.DataObject > charges =
        masterObject.getChildren('zqu__QuoteRatePlanCharge__c');
    logs.add('# Rate Plan Charges: ' + charges.size() );

    // Iterate over charges added in product selector in order to update pricing details
    for (zqu.DataObject charge : charges) {
      if (charge.get('zqu__Model__c') == 'Flat Fee Pricing') {
        // Update the effective price on flat fee charges
        charge.put('zqu__EffectivePrice__c', chargeEffectivePrice);
        logs.add('Updating list price of charge (' +
            charge.get('Name') + ') to ' +
            chargeEffectivePrice + '.');
      }

      // Detect if charge contains tier data
      if (charge.get('zqu__Model__c') == 'Tiered Pricing'
          || charge.get('zqu__Model__c') == 'Volume Pricing') {

        // Get the list of tiers on the charge object and update tier pricing
        zqu.ZChargeDataObject chargeObject = (zqu.ZChargeDataObject) charge;
        List<zqu__QuoteCharge_Tier__c> tiers =
            chargeObject.getCharge().chargeTiersObjects;
        if (tiers != null && tiers.size() > 0) {
          for (zqu__QuoteCharge_Tier__c tier : tiers) {
            tier.zqu__Discount__c = tierDiscount;
          }
          logs.add('Updating the tiers on charge (' + charge.get('Name') + ').');
          // Populate the changed tier information.
          chargeObject.rePopulateCustomChargeTiers(tiers);
        }
      }
    }

    // Validation Error
    if(plans.size() == 0){
      throw new zqu.CustomValidationException(
          'Please add a rate plan to the Quote.');
    }
  }

  global Boolean isUpdateAction() { return true; }
  global Boolean isAddRemoveAction() { return true; }
  global Boolean isValidateAction() { return true; }
}
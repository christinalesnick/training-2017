public with sharing class CustomEditQuoteProductsController {

  public zqu.EditQuoteProductOptions editProductOptions {
    get;
    set;
  }

  public CustomEditQuoteProductsController(ApexPages.StandardController controller){
    System.debug(LoggingLevel.INFO, 'Enter CustomEditQuoteProductsController');
    editProductOptions = new zqu.EditQuoteProductOptions();
    editProductOptions.guidedSellingOptions
        = new zqu.ProductBundleGuidedSellingOptions();
    editProductOptions.guidedSellingOptions.quoteType = 'Subscription';
    editProductOptions.productSelectorOptions
        = new zqu.SelectProductComponentOptions();
    editProductOptions.productSelectorOptions.quoteType = 'Subscription';
    editProductOptions.initialComponentMode
        = zqu.EditQuoteProductOptions.GUIDED_SELLING_MODE;
    System.debug(LoggingLevel.INFO, 'Exit CustomEditQuoteProductsController');
  }

  @RemoteAction
  public static Map<String, Object> getDiscount() {
    return new Map<String, Object> {
        'discount' => 10
    };
  }
}

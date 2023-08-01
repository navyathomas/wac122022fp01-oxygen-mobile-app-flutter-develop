import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:oxygen/models/service_request_body_model.dart';
import 'package:oxygen/services/shared_preference_helper.dart';

import 'app_config.dart';
import 'gql_client.dart';
import 'helpers.dart';

enum ApiExceptions { networkError, noData }

class ServiceConfig {
  Future<dynamic> _mutationData(String query) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      dynamic res = await GraphQLClientConfiguration.instance.mutation(query);
      return res ?? ApiExceptions.noData;
    } else {
      return ApiExceptions.networkError;
    }
  }

  Future<dynamic> _queryData(String query) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      dynamic res = GraphQLClientConfiguration.instance.query(query);
      return res ?? ApiExceptions.noData;
    } else {
      return ApiExceptions.networkError;
    }
  }

  Future<dynamic> createEmptyCart() async {
    String query = '''
        mutation{
          createEmptyCart
        }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> checkCustomerAlreadyExists(String emailOrMobile) async {
    String query = '''
     { 
      checkCustomerAlreadyExists(value:"$emailOrMobile")
     }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> sendRegistrationOtp(String value, bool isResend) async {
    String query = '''
        mutation{
          sendRegistrationOtp(value: "$value", is_resend: $isResend)
        }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> sendLoginOtp(String value, bool isResend) async {
    String query = '''
        mutation{
          sendLoginOtp(value: "$value", is_resend: $isResend)
        }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> sendForgotPasswordOtp(String value, bool isResend) async {
    String query = '''
        mutation{
          sendForgotpasswordOtp(value: "$value", is_resend: $isResend)
        }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> registrationUsingOtp(
      {required String mobileNumber,
      required String otp,
      required String firstName,
      required String lastName,
      required String password,
      required String email}) async {
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    String query = osUserID == null
        ? '''
      mutation{
       registrationUsingOtp(value:"$mobileNumber",
        otp:"$otp",
        firstname:"$firstName",
        lastname:"$lastName",
        email:"$email",
        password: "$password"){
          customer {
            firstname
            lastname
            email
            mobile_number
          }
          token
        }
      }
  '''
        : '''
      mutation{
       registrationUsingOtp(value:"$mobileNumber",
        otp:"$otp",
        firstname:"$firstName",
        lastname:"$lastName",
        email:"$email",
        password: "$password",
        device_player_id: "$osUserID"){
          customer {
            firstname
            lastname
            email
            mobile_number
          }
          token
        }
      }
  ''';
    return _mutationData(query);
  }

  Future<dynamic> loginUsingOtp(String value, String otp) async {
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    String query = osUserID == null
        ? '''
        mutation{
          loginUsingOtp(value:"$value", otp:"$otp") {
            token,
            customer{
              email
              firstname
              lastname
              mobile_number
  	        }
          }
        }
    '''
        : '''
        mutation{
          loginUsingOtp(value:"$value", otp:"$otp", device_player_id: "$osUserID") {
            token,
            customer{
              email
              firstname
              lastname
              mobile_number
  	        }
          }
        }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> changeCustomerPasswordOtp(
      String value, String otp, String password) async {
    String query = '''
        mutation{
          changeCustomerPasswordOtp(value:"$value", otp:"$otp", password: "$password")
          }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> loginUsingPassword(String value, String password) async {
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    String query = osUserID == null
        ? '''
      mutation {
        generateCustomerToken(email: "$value", password: "$password") {
          token
        }
      }
    '''
        : '''
      mutation {
        generateCustomerToken(email: "$value", password: "$password", device_player_id: "$osUserID") {
          token
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> createCustomerCart() async {
    String query = '''
        query{
          customerCart{
            id
          }
        }
    ''';
    return _queryData(query);
  }

  Future<dynamic> mergeCartId(String emptyCartId, String customerId) async {
    String query = '''
      mutation{
        mergeCarts(source_cart_id:"$emptyCartId", destination_cart_id:"$customerId") {
          id
          items{
            variation_data {
            product_url_key
            sku
            }
          }
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getAuthCustomerData() async {
    String query = '''
      query{
        customer {
          email
          firstname
          lastname
          mobile_number
        }
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getCustomerProfileData() async {
    String query = '''
      query{
        customer{
          firstname
	        lastname
	        email
	        mobile_number
          gender
          date_of_birth
        }
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> changeCustomerPassword(
      String currentPassword, String newPassword) async {
    String query = '''
      mutation {
        changeCustomerPassword(currentPassword: "$currentPassword" newPassword: "$newPassword") {
      email
  }
}
''';
    return _mutationData(query);
  }

  Future<dynamic> getRegionsList({String? countryCode = 'IN'}) async {
    String query = '''
      query {
        country(id: "$countryCode") {
          id
          available_regions {
            id
            code
            name
            available_districts {
              name
            }
          }
      }
    }  
    ''';
    return _queryData(query);
  }

  Future<dynamic> addCustomerAddress({
    String? countryCode = 'IN',
    required String firstName,
    required String lastName,
    required String contactNumber,
    required String address,
    required String pincode,
    required String city,
    required String addressType,
    required String locality,
    bool? openSunday,
    bool? openSaturday,
    required bool defaultAddress,
    required Map<String, dynamic> region,
  }) async {
    String query = '''
    mutation{
      createCustomerAddress(input:{
      country_code: $countryCode
      firstname: "$firstName"
      lastname: "$lastName"
      telephone: "+91$contactNumber"
      street: ["$address", "$locality"]
      postcode:" $pincode"
      city:" $city"
      addresstype: "$addressType"
      default_shipping: $defaultAddress
      default_billing: false
       ${addressType == '1' ? 'workdays:"{open_on_saturdays:$openSaturday,open_on_sundays:$openSunday}"' : ''}
      region: {
        region_code: "${region['region_code']}"
        region: "${region['region']}"
        region_id: ${region['region_id']}
      }
      }){
        id
        }
      }''';
    return _mutationData(query);
  }

  Future<dynamic> getCustomerAddresses() async {
    String query = '''
      query{
        customer{
	        addresses {
            id
  	        city
  	        country_code
            default_billing
  	        default_shipping
  	        firstname
  	        lastname
  	        postcode
  	        street
  	        telephone
            addresstype
            workdays
            region{
              region_code
              region
            }
  	      }
        }
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> updateCustomerDefaultAddress(
      {required int id, bool? defaultAddress = true}) async {
    String query = '''
      mutation{
        updateCustomerAddress(id: $id, input: {
          default_shipping: $defaultAddress,
          default_billing: $defaultAddress
        }){
          default_shipping
          default_billing
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> updateCustomerAddress(
    int id, {
    required String firstName,
    required String lastName,
    required String contactNumber,
    required String address,
    required String pincode,
    required String city,
    required String addressType,
    required String locality,
    bool? openSunday,
    bool? openSaturday,
    required bool defaultAddress,
    required Map<String, dynamic> region,
  }) async {
    String query = '''
      mutation {
        updateCustomerAddress(
          id: $id
          input: {
            firstname: "$firstName"
            lastname: "$lastName"
            telephone: "+91$contactNumber"
            postcode: "$pincode"
            street:  ["$address", "$locality"]
            city: "$city"
            addresstype: "$addressType"
            default_shipping: $defaultAddress
            default_billing: false
           ${addressType == '1' ? 'workdays:"{open_on_saturdays:$openSaturday,open_on_sundays:$openSunday}"' : ''}
            region: {
              region_code: "${region['region_code']}"
              region: "${region['region']}"
            }
          }){
            id
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> removeCustomerAddress({required int addressId}) async {
    String query = '''
      mutation {
        deleteCustomerAddress(id: $addressId)
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> addToWishList(String sku) async {
    String query = '''
      mutation {
        saveWishlistItem(wishlistItem: {
          sku: "$sku"
          quantity: 1
        }) {
          id
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> removeFromWishlist(int itemId) async {
    String query = '''
      mutation {
        removeProductFromWishlist(itemId: $itemId)
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getHomeData() async {
    String query = '''
      query{
        homepageAppCms {
	        content
	        content_type
	        footer_html_block
	        header_html_block
	        meta_description
	        meta_keywords
	        meta_title
	        title
        }
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getStores({
    required int pageSize,
    required int currentPage,
    String? district,
  }) async {
    String query = '''
    query{
      storePage(pageSize: $pageSize, currentPage: $currentPage, ${district != null ? "district:\"$district\"" : ""}) {
        description
        page_info {
          current_page
          page_size
          total_pages
        }
        stores
        title
        totalCount
      }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getDistrictList() async {
    String query = '''
      query{
        getDistricts
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getWishListProductSkuList() async {
    String query = '''
      query{
        customer {
          wishlist {
            items {
              id
              product{
                sku
              }
            }
          }
        }        
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getWishListProduct() async {
    String query = '''
      query{
        customer {
          wishlist {
            items {
              id
              product{
                sku
                name
                highlight
                new_from_date
                new_to_date
                small_image{
                  url
                }
                stock_status
                product_sticker{
                  image_url
                }
                price_range{
                  maximum_price{
                    discount{
                      amount_off
                      percent_off
                    }
                    regular_price{
                      currency
                      value
                    }
                    final_price{
                      currency
                      value
                    }
                  }
                }
              }
            }
            items_count
          }
        }
      }            
    ''';
    return _queryData(query);
  }

  Future<dynamic> getCartProductSkuList() async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
      query{
       cart(cart_id: "$cartId") {
         items{
           id
           quantity
           product{
             sku
           }
           ... on SimpleCartItem{
             simple_addon_options: customizable_options{
               label
               values {
                 label
                 price{
                   units
                   value
                   type
                 }
                 value
               }
             }
           }
           ... on ConfigurableCartItem {
            variation_data {
              product_url_key
              sku
              thumbnail
            }
            child_customizable_options {
              label
              values {
                label
                price {
                  type
                  value
                }
                value
              }
            } 
          }
         }
       }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getProductDetails({required String sku}) async {
    String query = '''
      query {
      products(filter: { sku: { eq: "$sku" } }) {
      items {
        id
        sku
        name
        __typename
        new_from_date
        new_to_date
        reward_points_text
      	reward_points
         media_gallery {
          url
        }
        product_sticker{
          image_url
        }
        buy_and_get_banner{
          url
          jpg_url 
        }
        bajaj_banner_image{
          url
          jpg_url 
         }
        small_image{
            url
          }
         product_type_set
        price_range {
          maximum_price {
            discount {
              amount_off
              percent_off
            }
            final_price {
              currency
              value
            }
            regular_price {
              currency
              value
            }
          }
        }
        
        description{
          html
        }
        
        crosssell_products{
          id
          sku
          name
          new_from_date
          new_to_date
          stock_status
          image {
          jpg_url
          }
         price_range {
          maximum_price {
            discount {
              amount_off
              percent_off
            }
            final_price {
              currency
              value
            }
            regular_price {
              currency
              value
            }
          }
        }
        }
        
        upsell_products{
          id
          sku
          name
          new_from_date
          new_to_date
          highlight
          qty_left_in_stock
          stock_status
          rating_aggregation_value
          product_review_count
          small_image{
            url
          }
          media_gallery{
            url
          }
          url_key
          product_sticker{
            image_url
          }
          image {
          jpg_url
          }
         price_range {
          maximum_price {
            discount {
              amount_off
              percent_off
            }
            final_price {
              currency
              value
            }
            regular_price {
              currency
              value
            }
          }
        }
        }
        
        related_products{
          id
          sku
          name
          new_from_date
          new_to_date
          highlight
          qty_left_in_stock
          stock_status
          rating_aggregation_value
          product_review_count
          small_image{
            url
          }
          media_gallery{
            url
          }
          url_key
          product_sticker{
            image_url
          }
          image {
          jpg_url
          }
         price_range {
          maximum_price {
            discount {
              amount_off
              percent_off
            }
            final_price {
              currency
              value
            }
            regular_price {
              currency
              value
            }
          }
        }
        }
        
        selected_variant_options{
          code
          value_index
          label
        }
        
        emi_data
        bajaj_emi
        bajaj_code
        stock_status
        qty_left_in_stock
        rating_aggregation_value
        product_review_count
        product_video{
          video_url
          video_title
        }
        highlight
        product_custom_attributes
        url_key
        reviews(
        pageSize: 3
        currentPage: 1
      ) {
        items {
          rating_value
          summary
          text
          created_at
          nickname
        }
      }
      
      ... on CustomizableProductInterface {
    options {
      title
      description
      required

      sort_order
      option_id
      ... on CustomizableDropDownOption {
        value {
          option_type_id
          price
          price_type
          sku
          sort_order
          title
        }
      }
    }
  }
        ... on ConfigurableProduct {
          configurable_options {
            attribute_code
            attribute_id
            id
            label
            values {
              non_existent_attributes
              label
              use_default_value
              value_index
              swatch_data {
                ... on ImageSwatchData {
                  thumbnail
                }
                value
              }
            }
          }
          variants {
            attributes {
              code
              value_index
            }
            product {
              id
              sku
              name
              __typename
              new_from_date
              new_to_date
              reward_points_text
      	      reward_points
              media_gallery {
                url
              }
              product_sticker{
                image_url
              }
              buy_and_get_banner{
                url
                jpg_url 
              }
              bajaj_banner_image{
                url
                jpg_url 
              }
              small_image{
            url
          }
          product_type_set
              price_range {
                maximum_price {
                  discount {
                    amount_off
                    percent_off
                  }
                  final_price {
                    currency
                    value
                  }
                  regular_price {
                    currency
                    value
                  }
                }
              }
              options {
              sort_order
              description
              title
              option_id
               terms_and_conditions {
                identifier
                link_label
               } 
         ... on CustomizableDropDownOption {
             value {
          			option_type_id
          			price
          			price_type
          			sku
          			title
        			}
           		}
            }
              emi_data
              bajaj_emi
              bajaj_code
              stock_status
              qty_left_in_stock
              rating_aggregation_value
              product_review_count
              product_video{
              video_url
              video_title
              }
              highlight
              product_custom_attributes
              url_key
              reviews(
        pageSize: 3
        currentPage: 1
      ) {
        items {
          rating_value
          summary
          text
          created_at
          nickname
        }
      }
            }
          }
        }
      }
      }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> searchProduct(int pageCount, int length, String product) {
    String query = '''
    query{
     products(
        currentPage: $pageCount
        pageSize: $length
        search: "$product")
        {
        items {
            id
            name
            sku
        }
    }
        }
        ''';

    return _queryData(query);
  }

  Future<dynamic> getSearchProductDetails(
      int pageCount,
      int length,
      String product,
      Map<String, dynamic> filterMap,
      Map<String, dynamic> sortMap) {
    String query = filterMap.isNotEmpty
        ? '''
    query { products(
        currentPage: $pageCount
        pageSize: $length
        search: "$product"
        filter:$filterMap
        sort:$sortMap
    ) {
        items {
        sku
      product_tag_label
      id
      name
      product_type_set
      new_from_date
      new_to_date
      stock_status
      highlight
      qty_left_in_stock
      bajaj_code
      media_gallery {
          url
        }
      small_image {
        url
      }
      product_sticker {
        image_url
        position
      }
      url_key
      price_range {
        maximum_price {
          discount {
            amount_off
            percent_off
          }
          final_price {
            currency
            value
          }
          regular_price {
            currency
            value
          }
        }
        minimum_price {
          discount {
            amount_off
            percent_off
          }
          final_price {
            currency
            value
          }
          regular_price {
            currency
            value
          }
        }
      }
    }
        page_info {
            total_pages
        }
        total_count
    }
 }

        '''
        : '''
    query { products(
        currentPage: $pageCount
        pageSize: $length
        search: "$product"
        sort:$sortMap
    ) {
        items {
        sku
      product_tag_label
      id
      name
      product_type_set
      new_from_date
      new_to_date
      stock_status
      highlight
      qty_left_in_stock
      bajaj_code
      media_gallery {
          url
        }
      small_image {
        url
      }
      product_sticker {
        image_url
        position
      }
      url_key
      price_range {
        maximum_price {
          discount {
            amount_off
            percent_off
          }
          final_price {
            currency
            value
          }
          regular_price {
            currency
            value
          }
        }
        minimum_price {
          discount {
            amount_off
            percent_off
          }
          final_price {
            currency
            value
          }
          regular_price {
            currency
            value
          }
        }
      }
    }
        page_info {
            total_pages
        }
        total_count
    }
 }

        ''';

    return _queryData(query);
  }

  Future<dynamic> getProductListDetails(int pageCount, int length,
      Map<String, dynamic> filterMap, Map<String, dynamic> sortMap) {
    String query = filterMap.isNotEmpty
        ? '''
    query { products(
        currentPage: $pageCount
        pageSize: $length
        filter:$filterMap
        sort:$sortMap
    ) {
        items {
        sku
      product_tag_label
      id
      name
      product_type_set
      new_from_date
      new_to_date
      stock_status
      highlight
      qty_left_in_stock
      bajaj_code
      media_gallery {
          url
        }
      small_image {
        url
      }
      product_sticker {
        image_url
        position
      }
      url_key
      price_range {
        maximum_price {
          discount {
            amount_off
            percent_off
          }
          final_price {
            currency
            value
          }
          regular_price {
            currency
            value
          }
        }
        minimum_price {
          discount {
            amount_off
            percent_off
          }
          final_price {
            currency
            value
          }
          regular_price {
            currency
            value
          }
        }
      }
    }
        page_info {
            total_pages
        }
        total_count
    }
 }

        '''
        : '''
    query { products(
        currentPage: $pageCount
        pageSize: $length
        sort:$sortMap
    ) {
        items {
        sku
      product_tag_label
      id
      name
      product_type_set
      new_from_date
      new_to_date
      stock_status
      highlight
      qty_left_in_stock
      bajaj_code
      media_gallery {
          url
        }
      small_image {
        url
      }
      product_sticker {
        image_url
        position
      }
      url_key
      price_range {
        maximum_price {
          discount {
            amount_off
            percent_off
          }
          final_price {
            currency
            value
          }
          regular_price {
            currency
            value
          }
        }
        minimum_price {
          discount {
            amount_off
            percent_off
          }
          final_price {
            currency
            value
          }
          regular_price {
            currency
            value
          }
        }
      }
    }
        page_info {
            total_pages
        }
        total_count
    }
 }

        ''';

    return _queryData(query);
  }

  Future<dynamic> getRecentlyViewedProducts() async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
    query{
  getRecentlyviewedProducts(cartid: "$cartId"){
    name
    sku
      small_image {
      url
    }
  }
}''';
    return _queryData(query);
  }

  Future<dynamic> getCategoryPageData() async {
    String query = '''
    query{
    getCategoryPageData {
    content
  }
  }''';
    return _queryData(query);
  }

  Future<dynamic> checkPinCode(
      {required int productId, required String pinCode}) async {
    String query = '''
      mutation {
        checkPincode(      
          product_id: $productId,
          pincode: "$pinCode",
        )
        {
         message
         status
        }
    }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getFaqLists(
      {required int currentPage, String? faqQuery}) async {
    String query = '''
      query{
        faqsList(pageSize: 20, currentPage: $currentPage, ${faqQuery != null ? "filter:{category_name: \"$faqQuery\"}" : ""}) {
          FAQs {
            answer  
            category {
              id
              name
            }
            entity_id
            question
          }
          page_info {
            current_page
            page_size
            total_pages
          }
          totalCount
        }
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getFaqQueries() async {
    String query = '''
      query{
        faqCategoriesList(pageSize: 20, currentPage: 1) {
          faqCategories {
            id
            name
          }
          page_info {
            current_page
            page_size
            total_pages
          }
          totalCount
        }
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getBankOffers({required String sku}) async {
    String query = '''
    {
  getBankOffersByProductSku(sku: "$sku") {
    bank_offer_detail {
      description
      identifier
      link_label
      title
    }
    id
    title
  }
}
''';
    return _queryData(query);
  }

  Future<dynamic> getReviews({required String sku, int pageNo = 1}) async {
    String query = '''
    {
     products(filter: { sku: { eq: "$sku" } }) {
      items {
        id
        sku
        name
        rating_aggregation_value
        product_review_count
        rating_summary_data {
    	    rating_count
    	    rating_value
  	    }
        reviews(
        pageSize: 10
        currentPage: $pageNo
      ) {
        page_info{
          current_page
          page_size
          total_pages
        }
        items {
          rating_value
          summary
          text
          created_at
          nickname
        }
      }
      }
      }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getMyOrders(
      {required int pageSize, required int currentPage}) async {
    String query = '''
     query{
  customerOrders(pageSize: $pageSize, currentPage: $currentPage) {
     
    items {
      id
      trackDeliveryStatus {
        title
        status {
          status
          status_label
          color_code
          is_active
          last_updated
        }
        expected_delivery {
          title
          date
        }
      }
      customerDeliveryDetails {
        customer_id
        customer_name
        customer_phone
        shipping_address
        billing_address 
      }
      deliveryitemDetails {
        title
        value
        color_code
      }
      order_payment_method {
        code
        method_title
      }
      current_status {
        status
        date
        value
      }
      shipping_addresses {
        addresstype
        firstname
        lastname
        street
        city
        postcode
        telephone
      }
      created_at 
      order_number
      status
      order_process
      products {
        id
        small_image{
          url
        }
        order_details{
          id
          name
          sku
          quantity
          regular_price
          final_price
          discount
          is_item_available_for_review
        }
      }
      prices{
        shipping_addresses {
          selected_shipping_method {
            amount {
              value
              currency
            }
          }
        }
        gst{
          cgst
          igst
          sgst
          shipping_gst
          total_gst
          currency
          gst_type
        }
        discount{
          amount{
            currency
            value
          }
          label
        }
        grand_total{
          currency
          value
        }
        subtotal_excluding_tax{
          currency
          value
        }
        subtotal_including_tax {
          currency
          value
        }
      }
      tracking_data{
        status
        url
      }
    }
    page_info{
      current_page
      page_size
      total_pages
      
    }
total_count  
  }
}
    ''';
    return _queryData(query);
  }

  Future<dynamic> getOfflineOrders() async {
    String query = '''
    query{
      customerOrdersOffline {
        items {
          id
          trackDeliveryStatus {
            title
            status {
              status
              status_label
              color_code
              is_active
              last_updated
            }
            expected_delivery {
              title
              date
            }
          }
          customerDeliveryDetails {
            customer_id
            customer_name
            customer_phone
            shipping_address
            billing_address 
          }
          deliveryitemDetails {
            title
            value
            color_code
          }
          order_payment_method {
            code
            method_title
          }
          current_status {
            status
            date
            value
          }
          shipping_addresses {
            addresstype
            firstname
            lastname
            street
            city
            postcode
            telephone
          }
          created_at 
          order_number
          status
          order_process
          products {
            id
            
            order_details{
              id
              name
              sku
              quantity
              regular_price
              final_price
              discount
              is_item_available_for_review
            }
          }
          prices{
            shipping_addresses {
              selected_shipping_method {
                amount {
                  value
                  currency
                }
              }
            }
            gst{
              cgst
              igst
              sgst
              shipping_gst
              total_gst
              currency
              gst_type
            }
            discount{
              amount{
                currency
                value
              }
              label
            }
            grand_total{
              currency
              value
            }
            subtotal_excluding_tax{
              currency
              value
            }
            subtotal_including_tax {
              currency
              value
            }
          }
          tracking_data{
            status
            url
          }
        }
      }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> addSimpleProductToCart(String sku,
      {int qty = 1, int? optionId, int? optionTypeId}) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String typeId = '"${optionTypeId ?? -1}"';
    String query = '''
      mutation {
        addSimpleProductsToCart(input: { cart_id: "$cartId", cart_items: [{
          data: {
            quantity : $qty,
            sku: "$sku"
          },
          ${optionId == null ? '' : "customizable_options: { id: $optionId, value_string : $typeId }"}
        }] }) {
        cart {
          id
          items{
            id
            product{
             sku
           }
          }
        }
      }
    }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> removeFromCart(int cartItemId) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();

    String query = '''
      mutation {
        removeItemFromCart(input: { cart_id: "$cartId", cart_item_id: $cartItemId }) {
          cart {
            id
          }
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> updateCartItem(int cartItemId, int qty,
      {int? optionId, int? optionTypeId}) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String typeId = '"${optionTypeId ?? -1}"';
    String query = '''
      mutation {
        updateCartItems(input: {
          cart_id: "$cartId",
          cart_items: {
            cart_item_id : $cartItemId,
            quantity: $qty,
            ${optionId == null ? '' : "customizable_options: { id: $optionId, value_string : $typeId }"}
          }
        })
        {
          cart {
            id
          }
        }
    }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getCartData() async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();

    String query = '''
    query{
      cart(cart_id: "$cartId") {
        reward_points_text
      	reward_points
        applied_coupons{
          code
        }
        shipping_addresses{
         selected_shipping_method{
          amount{
            value
            currency
          }
         }
        }
        items{
          id
          quantity
          addon_options {
        title
        option_id
          ... on CustomizableDropDownOption {
            value {
              option_type_id
              price
              sku
              title
            }
          }
        }
        ... on SimpleCartItem{
         simple_addon_options: customizable_options{
           label
           values {
             label
             price{
               units
               value
               type
             }
             value
           }
         }
       }
          ... on ConfigurableCartItem {
            variation_data {
              product_url_key
              sku
              thumbnail
            }
            configurable_addon_options: child_customizable_options {
            label
            values {
              label
              price {
                type
                value
              }
              value
            }
            } 
          }
          variation_data {
            sku
            thumbnail
          }
          product{
            sku
            name
            stock_status
            product_quantity
            small_image{
              url
            }
            price_range{
              maximum_price{
                final_price{
                  value
                  currency
                }
                regular_price{
                  value
                  currency
                }
                discount{
                  percent_off
                  amount_off
                }
              }
            }
          } 
        }
        prices {
          applied_taxes {
            amount {
              currency
              value
            }
          }
          bajaj_emi {
            label
            amount {
              value
              currency
            }
          }
          discounts {
            amount {
              currency
              value
            }
            label
          }
          grand_total {
            value
            currency
          }
          subtotal_excluding_tax {
            currency
            value
          }
          gst {
            currency
            total_gst
            cgst
            gst_type
            igst
            sgst
            shipping_gst
          }
          subtotal_including_tax {
            currency
            value
          }
        }
      }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getSearchAggregationsList(
      String product, Map<String, dynamic> filterMap) async {
    String query = filterMap.isNotEmpty
        ? '''
    query {
  products(currentPage: 1, pageSize: 10, search: "$product",filter: $filterMap) {
    sort_fields {
      default
      default_direction
      options {
        label
        sort_direction
        value
      }
    }
    aggregations {
      attribute_code
      label
      options {
        label
        value
        swatch_data {
          color_type
          value
        }
      }
    }
  }
}'''
        : '''
    query {
  products(currentPage: 1, pageSize: 10, search: "$product") {
    sort_fields {
      default
      default_direction
      options {
        label
        sort_direction
        value
      }
    }
    aggregations {
      attribute_code
      label
      options {
        label
        value
        swatch_data {
          color_type
          value
        }
      }
    }
  }
}''';
    return _queryData(query);
  }

  Future<dynamic> getAggregationsList(Map<String, dynamic> filterMap) async {
    String query = '''
    query {
  products(currentPage: 1, pageSize: 10,filter: $filterMap) {
    sort_fields {
      default
      default_direction
      options {
        label
        sort_direction
        value
      }
    }
    aggregations {
      attribute_code
      label
      options {
        label
        value
        swatch_data {
          color_type
          value
        }
      }
    }
  }
}''';

    return _queryData(query);
  }

  Future<dynamic> getCmsBlocks({required String identifier}) async {
    String query = '''
      query{
       cmsBlocks(identifiers: ["$identifier"]) {
       items {
      content
      identifier
      title
     }
   }
   }
    ''';
    return _queryData(query);
  }

  Future<dynamic> postCustomerFeedback({
    required String name,
    required String mobile,
    required int rating,
    required String email,
    required String feedback,
  }) async {
    String query = '''
      mutation {
        submitContactForm(input: {
          name: "$name",
          telephone: "$mobile",
          app_rating: $rating,
          email: "$email",
          comment: """$feedback""",
          request_type :" Mobile app feedback"
        })
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getTermsAndConditions() async {
    String query = '''
      query{
        cmsPage(identifier: "terms-and-conditions") {
          url_key
          content
          content_heading
          title
          page_layout
          meta_title 
          meta_keywords 
          meta_description
        }
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getPrivacyPolicies() async {
    String query = '''
      query{
        cmsPage(identifier: "privacy-policy-cookie-restriction-mode") {
          url_key
          content
          content_heading
          title
          page_layout
          meta_title 
          meta_keywords 
          meta_description
        }
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getLatestOffers() async {
    String query = '''
      query{
        OfferpageAppCms {
          content
        }
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getSearchCategories() async {
    String query = '''
    query{
  getMobileAppSearchPageData {
    content
    title
}
  }''';
    return _queryData(query);
  }

  Future<dynamic> getCategoryDetailed({required String type}) async {
    String query = '''
      query{
      categoryDetailedPageCms(type: "$type")
      {
       content
      }
     }
    ''';
    return _queryData(query);
  }

  Future<dynamic> addConfigurableToCart(
      {required String parentSku,
      required String sku,
      int qty = 1,
      int? optionId,
      int? optionTypeId}) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String typeId = '"${optionTypeId ?? -1}"';
    String query = '''
      mutation {
        addConfigurableProductsToCart(
          input: { 
            cart_id: "$cartId", 
              cart_items: {
                parent_sku : "$parentSku",
                data : { sku: "$sku", quantity: $qty },
                ${optionId == null ? '' : "customizable_options: { id: $optionId, value_string : $typeId }"}
              },
            }
        ){
          cart {
          id
          items{
            id
            ... on ConfigurableCartItem {
            variation_data {
              sku
            } 
          }
            product{
             sku
           }
          }
        }
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> addCouponToCart(String couponCode) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
      mutation{
        applyCouponToCart(input: {
          cart_id : "$cartId",
          coupon_code : "$couponCode"
        }){
         cart{
           applied_coupons{
             code
           }
         } 
        }
      }
  
    ''';
    return _mutationData(query);
  }

  Future<dynamic> removeCouponFromCart() async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
      mutation{
        removeCouponFromCart(input:{
          cart_id: "$cartId"
        }){
          cart{
          id
          }
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> checkRefreshToken(String tokenId) async {
    String query = '''
    query{
      checkCustomerTokenValidV2(token: "$tokenId"){
        refresh_token_id
        status
      }
    }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> refreshToken(String tokenId, String email) async {
    String query = '''
    query {
      customerRefreshToken(refresh_token_id:"$tokenId" email:"$email")
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> removeOptionItemFromCart(
      int cartItemId, int optionTypeId) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
    mutation {
        removeOptionItemFromCart (
          cart_id: "$cartId"
          cart_item_id: $cartItemId
          option_item_id: $optionTypeId
        )
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> updateCustomerGeneralInformations({
    required String firstName,
    required String lastName,
    // required int gender,
    required String dateOfBirth,
  }) async {
    String query = '''
      mutation {
        updateCustomer(input: {
          firstname: "$firstName",
          lastname: "$lastName",
          date_of_birth:"$dateOfBirth" 
        }){
          customer {
            firstname
            lastname
            email
            mobile_number
            gender
            date_of_birth
          }
        }
      }
      ''';
    return _mutationData(query);
  }

  Future<dynamic> getReasonsForAccountDeletion() async {
    String query = '''
      query {
        reasonsForCustomerDeletion
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getItemByUrlKey({required String urlKey}) async {
    String query = '''
      {
         products(filter:{url_key:{eq:"$urlKey"}}){
           items{
              sku
             }
           }
       }
    ''';
    return _queryData(query);
  }

  Future<dynamic> revokeCustomerToken() async {
    String query = '''
    mutation {
      revokeCustomerToken {
        result
      }
    }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> setShippingAddress(String addressId) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = ''' mutation {
       setShippingAddressesOnCart(
    input: {
      cart_id: "$cartId"
      shipping_addresses: { customer_address_id: $addressId}
    }
  ) {
    cart {
      id
      is_virtual
         shipping_addresses {
        addresstype
        available_shipping_methods {
          carrier_code
          carrier_title
          error_message
          method_code
          method_title
        }
      }
    }
  }
    }''';
    return _mutationData(query);
  }

  Future<dynamic> setBillingAddress(String billingAddressId) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''mutation {
  setBillingAddressOnCart(
    input: {
      cart_id: "$cartId"
      billing_address: { customer_address_id: $billingAddressId}
    }
  ) {
    cart {
      id
      is_virtual
    }
  }
}
''';
    return _mutationData(query);
  }

  Future<dynamic> submitReview(
      {required String sku,
      required String summary,
      String? text,
      required int ratingValue,
      String? nickName}) async {
    String query = '''
    mutation{ 
    createProductReview (
        input: {
            sku: "$sku",
            nickname: "${nickName ?? ""}",
            text: """${text ?? ""}""",
            summary: "$summary",
            rating_value: $ratingValue
        }
    ){
        review {
            nickname
            summary
            text
            average_rating
        }
    }
}
    ''';
    return _mutationData(query);
  }

  Future<dynamic> sendDeleteAccountOtp(
      {required String email, required bool isResend}) async {
    String query = '''
      mutation{
        sendDeleteCustomerOtp(
          value: "$email"
          is_resend:$isResend
        )
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> deleteCustomerAccount(
      {required String reason,
      String? comment,
      required String email,
      required String otp}) async {
    String query = '''
      mutation{
        deleteCustomerAccount(
          reason: "$reason",
          comment: "${comment ?? ""}",
          value: "$email",
          otp: "$otp"
        ){
          status
          message
          reason
          comment
          }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getPaymentMethods() async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''query {
    cart(cart_id: "$cartId") {
      available_payment_methods {
        code
        title
        image_url
        description
        mobile_image_url
      }
       available_payment_modes {
        code
        description
        image_url
        mobile_image_link
        short_description
        title
      }
    }
  }''';
    return _queryData(query);
  }

  Future<dynamic> getAvailablePaymentModes() async {
    String query = '''query{
      getMobileAppPaymentModes {
        title
        image_url
        type
        payment_methods {
          title
          payment_code
        }
      }
    }''';
    return _queryData(query);
  }

  Future<dynamic> setPaymentMethod(String paymentCode) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''mutation {
  setPaymentMethodOnCart(
    input: {
      cart_id: "$cartId"
      payment_method: { code: "$paymentCode" }
    }
  ) {
    cart {
      id
    }
  }
}''';
    return _mutationData(query);
  }

  Future<dynamic> placeOrder() async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
      mutation {
        placeOrder(input: { cart_id: "$cartId" }) {
          order {
            action_url
            action_url_mob
            order_number
            payu{
              url
              redirectHTML
              redirectlink
            }
          }
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> setShippingMethod(
      String carrierCode, String methodCode) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''mutation {
      setShippingMethodsOnCart(
        input: {
          cart_id: "$cartId"
          shipping_methods: [{ carrier_code: "$carrierCode", method_code: "$methodCode" }]
        }
      ) {
        cart {
          id
        }
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> restoreCustomerCart(bool restoreCart) async {
    String action = restoreCart ? "restore_cart" : "cancel_order";
    String query = '''mutation {
      restoreAction(action:"$action") {
        status
        message
      }
    }''';
    return _mutationData(query);
  }

  Future<dynamic> checkRestoreCart() async {
    String query = '''query{
      customer{
        is_redirected
        popup_message
      }
    }''';
    return _mutationData(query);
  }

  Future<dynamic> getStockNotification(
      {required String email, required int id}) async {
    String query = '''
    mutation {
          getStockNotificationAlertToEmail(email: "$email", product_id: $id)
        }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getOrderDetails() async {
    String query = '''query {
  customerOrders(lastorder: true) {
    items {
      order_number
      order_payment_method {
        code
        method_title
        purchase_order_number
      }
      order_shipping_method {
        amount {
          currency
          value
        }
      }
      prices {
        discount {
          amount {
            currency
            value
          }
          label
        }
        grand_total {
          value
          currency
        }
        gst {
          currency
          total_gst
          sgst
          cgst
          igst
        }
      }

      products {
        order_details {
          discount
          final_price
          id
          name
          quantity
          regular_price
          sku
        }

        thumbnail {
          url
        }
      }
    }
  }
}
''';
    return _queryData(query);
  }

  Future<dynamic> getTrendingSearches() async {
    String query = '''query{
  getMobileAppSearchPageData {
    content
  }
  }''';
    return _queryData(query);
  }

  Future<dynamic> sendCustomerUpdateOtp(
      {required String value,
      bool? resend = false,
      String type = 'mobile'}) async {
    String query = type == 'mobile'
        ? '''
      mutation{
        sendOtpUpdateCustomer(value: "+91$value", is_resend: $resend)
      }
    '''
        : '''
      mutation{
        sendOtpUpdateCustomer(value: "$value", is_resend: $resend)
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> updateCustomerEmailOrMobile(
      {required String value,
      required String newValue,
      required String otp,
      String type = 'mobile'}) async {
    String query = type == 'mobile'
        ? '''
      mutation {
        updateCustomerEmailMobile (value: "+91$value",
                            otp: "$otp"
                            new_value: "+91$newValue")
      }
    '''
        : '''
      mutation {
        updateCustomerEmailMobile (value: "$value",
                            otp: "$otp"
                            new_value: "$newValue")
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getNotificationList() async {
    String query = '''
      query{
        wacNotificationsList {
          title
          total_count
          items {
            name
            short_description
            date
            type
            link_type
            link_id
            increment_id
          }
        }
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> addProductToCompare(String productId) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = ''' mutation {
        addProductToCompare(
              input: { cart_id: "$cartId", product_id: "$productId" }
          )
     }''';
    return _mutationData(query);
  }

  Future<dynamic> removeProductFromCompare(String productId) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''mutation {
  removeProductFromComapre(
    input: { cart_id: "$cartId", product_id: "$productId" }
  )
}''';
    return _mutationData(query);
  }

  Future<dynamic> addToRecentlyViewed({required int productId}) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
    mutation {
        addtoRecentlyviewed(cartid: "$cartId", productid: "$productId") {
          name    
          }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getContactUsData() async {
    String query = '''
      query {
        getmobilecontactus{
          address {
            title
            content
          } 
        email {
          title
          content
        }
        showroom{
          title
          call
          hour
        }
        support {
          title
          call
          hour
        }
        location{
          latitude
          longitude
        }
      }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getBajajEmiDetails({required String sku}) async {
    String query = '''
      mutation {
          getBajajEMIDetails(sku: "$sku") {
            columns
            items {
            id
            schemeId
            values
            }
        sub_title
        title
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> unsetBajajEmiDetails() async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
      mutation{
        unSetBajajEmi(cart_id: "$cartId")
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> checkScheme(String cardNumber) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
        mutation {
          customerBlillingSearch(cart_id: "$cartId", card_number: "$cardNumber") {
          city
          intercity
          items {
            columns
            items{
              id
              schemeId
              values
              }
            sub_title
            title
          }
          }
         }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> setEmiScheme({required String schemeId}) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
      mutation {
        setEmiScheme(cart_id: "$cartId", schemeId: "$schemeId") {
          cart {
            id
            is_virtual
            total_quantity
          }
          status
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getCurrentSchemeDetails() async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
      {
        cart(cart_id:"$cartId"){
        selected_scheme {
            columns
            items {
               id
               schemeId
               values
            }
          }
          }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> generateBajajEmiOtp({
    required String cardNumber,
    required String city,
    required bool intercity,
    required String schemeId,
  }) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
      mutation {
          CustomerBillingOtp(
            cart_id: "$cartId"
            card_number: "$cardNumber"
            city: "$city"
            intercity: $intercity
            schemeId: "$schemeId"
          )
        }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> verifyBajajEmiOtp({
    required String cardNumber,
    required String schemeId,
    required String otp,
  }) async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''
      mutation {
          CustomerBillingAuth(
          cart_id: "$cartId"
          card_number: "$cardNumber"
          schemeId: "$schemeId"
          otp: "$otp"
          ) {
            ref_no
            status
            }
        }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getBajajTermsAndConditions() async {
    String query = '''
      {
        getBajajTermsConditions {
          title
          description
        }
      }
    ''';
    return _mutationData(query);
  }

  Future<dynamic> getForceUpdateData() async {
    String query = '''
    query {
      mobileForceUpdate {
        android_min_version
        android_max_version
        ios_min_version
        ios_max_version
      }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> removeAllProductsFromCompare() async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''mutation {
  removeallProductFromComapre(
    input: { cart_id: "$cartId" }
  )
}''';
    return _mutationData(query);
  }

  Future<dynamic> getCompareProductsDetails() async {
    String cartId =
        AppConfig.cartId ?? await SharedPreferencesHelper.getCartId();
    String query = '''{
  getCompareProducts(cart_id: "$cartId") {
    comparable_attributes
    discount
    image
    price
    product_id
    product_name
    regular_price
    url
    product_interface{
      sku
      __typename
      product_type_set
    }
  }
}''';
    return _queryData(query);
  }

  Future<dynamic> getLoyaltyProductPoints() async {
    String query = '''
    {
      WacLoyalityProduct {
        created_at
        credited
        label
        points
      }
    }''';
    return _queryData(query);
  }

  Future<dynamic> getLoyaltyBillPoints() async {
    String query = '''
    {
      WacLoyalityBilling {
        created_at
        credited
        label
        points
      }
    }''';
    return _queryData(query);
  }

  Future<dynamic> getTotalLoyaltyPoint() async {
    String query = '''
      query{
        customer {
          total_rewards
        }        
      }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getServiceList() async {
    String query = '''
    {
      servicelisting{
        service_id 
        category_type 
        Brand 
        Model 
        Serial_number
        issue_description 
        json_image 
        Service_request_type
        district 
        store 
        product_from
        title
        customer_id 
        phone_number
        status
        created_at
     }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getTrackJobList() async {
    String query = '''
    {
      customer{
        trackJobsList {
           id
           job_id
           item_name
           status
           color_code
           complaint
           estimated_delivery
          }
	    }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getJobStatusDetails({required String jobId}) async {
    String query = '''
      {
       jobStatusDetails(job_id:"$jobId") {
        lastStatusUpdate {
          last_updated_date
          updated_by
        }
        customerDetails {
          billing_address
          customer_id
          customer_name
          customer_phone
          shipping_address
        }
        itemDetails {
          color_code
          title
          value
        }
        jobCategory {
          gst
          job_category
          job_id
          store_code
        }
        jobDetails {
          accessories_recieved
          account_closed
          assigned_to
          complaint
          contact_details
          current_condition
          expected_delivery
          job_added_by
          job_added_on
        }
        jobStatus {
          color_code
          is_active
          status
        }
      }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getServiceRequestData() async {
    String query = '''{
  getServiceRequestData {
    data {
      label
      value
    }
    label
    type
  }
}''';
    return _queryData(query);
  }

  Future<dynamic> createServiceRequest(
      ServiceRequestBody serviceRequestBody) async {
    List<String> photoList = [];
    for (int i = 0; i < serviceRequestBody.addPhotoList!.length; i++) {
      photoList.add('"${serviceRequestBody.addPhotoList![i]}"');
    }
    String query = '''mutation {
  CreateServiceRequest(
    input: {
      category_type: "${serviceRequestBody.categoryType}"
      title:"${serviceRequestBody.title}"
      brand: "${serviceRequestBody.brand}"
      model: "${serviceRequestBody.model}"
      issue_description: "${serviceRequestBody.issueDescription}"
      add_photo: $photoList
      service_request_type: "${serviceRequestBody.serviceRequestType}"
      select_district: "${serviceRequestBody.selectDistrict}"
      store: "${serviceRequestBody.store}"
      product_from: "${serviceRequestBody.productFrom}"
      pickup_address:"${serviceRequestBody.pickupAddress}"
      serial_number:"${serviceRequestBody.serialNumber}"
      warrenty:"${serviceRequestBody.warranty}"
    }
  ) {
    message
  }
}''';
    return _mutationData(query);
  }

  Future<dynamic> getServiceRequestDemoData(String orderId, String itemId) {
    String query = ''' {
  getServiceRequestDataWeb(order_id: "$orderId", item_id: "$itemId") {
    data {
      data {
        is_selected
        label
        value
      }
      label
      title
      type
    }
    product_name
  
}
}''';
    return _queryData(query);
  }

  Future<dynamic> getEmiPlans({required String sku}) async {
    String query = '''
    {
      getBankEmiByProductSku(sku:"$sku"){
          id
          title
          bank{
            name
            alt
            logo
            bank_id
            plans{
            month
            interest
            emi
            bank_id
          }
         }
        }
    }
    ''';
    return _queryData(query);
  }

  Future<dynamic> getWhatsappChatConfiguration() async {
    String query = '''
    {
       whatsappConfigurationStatus{
       config_status
       mobilenumber
       }
    }
    ''';
    return _queryData(query);
  }
}

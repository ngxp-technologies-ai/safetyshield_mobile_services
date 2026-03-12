import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const String _userTokenKey = "secured_token";
  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _userRoleKey = "user_role";
  static const String _storeIdKey = "store_id";
  static const String _receiptTemplateKey = "receipt_template_id";
  static const String _printerAddressKey = "printer_address";
  static const String _printerNameKey = "printer_name";
  static const String _kotPrintersKey = "kot_printers";
  static const String _kotBluetoothEnabledKey = "kot_bluetooth_enabled";
  static const String _kotPaperSizeKey = "kot_paper_size";
  static const String _customThankYouKey = "custom_thank_you_message";
  static const String _customFooterMessageKey = "custom_footer_message";
  static const String _showReturnPolicyKey = "show_return_policy";
  static const String _returnPolicyTextKey = "return_policy_text";
  static const String _showAmountInWordsKey = "show_amount_in_words";
  static const String _showCashReceivedKey = "show_cash_received";
  static const String _showBalanceGivenKey = "show_balance_given";
  static const String _showItemMrpKey = "show_item_mrp";
  static const String _showItemRateKey = "show_item_rate";
  static const String _showItemTotalKey = "show_item_total";
  static const String _showItemHsnKey = "show_item_hsn";
  static const String _userModuleNameKey = "user_module_name";

  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  //store user token (legacy method)
  static Future<void> storeUserToken(String token) async {
    if (token.isNotEmpty) {
      try {
        await _storage.write(key: _userTokenKey, value: token);
        log("Token stored successfully");
      } catch (e) {
        log("Failed to store token: $e");
      }
    }
  }

  //store access token
  static Future<void> storeAccessToken(String token) async {
    if (token.isNotEmpty) {
      try {
        await _storage.write(key: _accessTokenKey, value: token);
        log("Access token stored successfully");
      } catch (e) {
        log("Failed to store access token: $e");
      }
    }
  }

  //store refresh token
  static Future<void> storeRefreshToken(String token) async {
    if (token.isNotEmpty) {
      try {
        await _storage.write(key: _refreshTokenKey, value: token);
        log("Refresh token stored successfully");
      } catch (e) {
        log("Failed to store refresh token: $e");
      }
    }
  }

  //get user token (legacy method)
  static String? getUserToken() {
    try {
      return _storage.read(key: _userTokenKey) as String?;
    } catch (e) {
      log("Failed to read token: $e");
      return null;
    }
  }

  //get access token
  static Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      log("Failed to read access token: $e");
      return null;
    }
  }

  //get refresh token
  static Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      log("Failed to read refresh token: $e");
      return null;
    }
  }

  //store user role
  static Future<void> storeUserRole(String role) async {
    if (role.isNotEmpty) {
      try {
        await _storage.write(key: _userRoleKey, value: role);
        log("User role stored successfully");
      } catch (e) {
        log("Failed to store user role: $e");
      }
    }
  }

  //get user role
  static Future<String?> getUserRole() async {
    try {
      return await _storage.read(key: _userRoleKey);
    } catch (e) {
      log("Failed to read user role: $e");
      return null;
    }
  }

  //store store id
  static Future<void> storeStoreId(String storeId) async {
    if (storeId.isNotEmpty) {
      try {
        await _storage.write(key: _storeIdKey, value: storeId);
        log("Store ID stored successfully: $storeId");
      } catch (e) {
        log("Failed to store store ID: $e");
      }
    }
  }

  //get store id
  static Future<String?> getStoreId() async {
    try {
      return await _storage.read(key: _storeIdKey);
    } catch (e) {
      log("Failed to read store ID: $e");
      return null;
    }
  }

  //store user module name
  static Future<void> storeUserModuleName(String moduleName) async {
    if (moduleName.isNotEmpty) {
      try {
        await _storage.write(key: _userModuleNameKey, value: moduleName);
        log("User module name stored successfully: $moduleName");
      } catch (e) {
        log("Failed to store user module name: $e");
      }
    }
  }

  //get user module name
  static Future<String?> getUserModuleName() async {
    try {
      return await _storage.read(key: _userModuleNameKey);
    } catch (e) {
      log("Failed to read user module name: $e");
      return null;
    }
  }

  //delete all tokens
  static Future<void> deleteAllTokens() async {
    try {
      await _storage.delete(key: _userTokenKey);
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await _storage.delete(key: _userRoleKey);
      await _storage.delete(key: _storeIdKey);
      log("All tokens deleted successfully");
    } catch (e) {
      log("Failed to delete tokens: $e");
    }
  }

  // ============ Receipt Template Settings ============

  //store selected receipt template ID
  static Future<void> storeReceiptTemplateId(String templateId) async {
    if (templateId.isNotEmpty) {
      try {
        await _storage.write(key: _receiptTemplateKey, value: templateId);
        log("Receipt template ID stored successfully");
      } catch (e) {
        log("Failed to store receipt template ID: $e");
      }
    }
  }

  //get selected receipt template ID
  static Future<String?> getReceiptTemplateId() async {
    try {
      return await _storage.read(key: _receiptTemplateKey);
    } catch (e) {
      log("Failed to read receipt template ID: $e");
      return null;
    }
  }

  // ============ Printer Settings ============

  //store printer address
  static Future<void> storePrinterAddress(String address) async {
    if (address.isNotEmpty) {
      try {
        await _storage.write(key: _printerAddressKey, value: address);
        log("Printer address stored successfully");
      } catch (e) {
        log("Failed to store printer address: $e");
      }
    }
  }

  //get printer address
  static Future<String?> getPrinterAddress() async {
    try {
      return await _storage.read(key: _printerAddressKey);
    } catch (e) {
      log("Failed to read printer address: $e");
      return null;
    }
  }

  //store printer name
  static Future<void> storePrinterName(String name) async {
    if (name.isNotEmpty) {
      try {
        await _storage.write(key: _printerNameKey, value: name);
        log("Printer name stored successfully");
      } catch (e) {
        log("Failed to store printer name: $e");
      }
    }
  }

  //get printer name
  static Future<String?> getPrinterName() async {
    try {
      return await _storage.read(key: _printerNameKey);
    } catch (e) {
      log("Failed to read printer name: $e");
      return null;
    }
  }

  //clear printer settings
  static Future<void> clearPrinterSettings() async {
    try {
      await _storage.delete(key: _printerAddressKey);
      await _storage.delete(key: _printerNameKey);
      log("Printer settings cleared successfully");
    } catch (e) {
      log("Failed to clear printer settings: $e");
    }
  }

  // ============ KOT Multi-Printer Settings ============

  //store KOT printers list as JSON
  static Future<void> storeKotPrinters(
      List<Map<String, dynamic>> printers) async {
    try {
      final jsonString = jsonEncode(printers);
      await _storage.write(key: _kotPrintersKey, value: jsonString);
      log("KOT printers stored successfully: ${printers.length} printers");
    } catch (e) {
      log("Failed to store KOT printers: $e");
    }
  }

  //get KOT printers list
  static Future<List<Map<String, dynamic>>> getKotPrinters() async {
    try {
      final jsonString = await _storage.read(key: _kotPrintersKey);
      if (jsonString == null || jsonString.isEmpty) return [];
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      log("Failed to read KOT printers: $e");
      return [];
    }
  }

  //clear KOT printers
  static Future<void> clearKotPrinters() async {
    try {
      await _storage.delete(key: _kotPrintersKey);
      log("KOT printers cleared successfully");
    } catch (e) {
      log("Failed to clear KOT printers: $e");
    }
  }

  // store whether Bluetooth printer is included for KOT printing
  static Future<void> storeKotBluetoothEnabled(bool enabled) async {
    try {
      await _storage.write(
          key: _kotBluetoothEnabledKey, value: enabled.toString());
    } catch (e) {
      log("Failed to store KOT bluetooth enabled: $e");
    }
  }

  // get whether Bluetooth printer is included for KOT printing
  static Future<bool> getKotBluetoothEnabled() async {
    try {
      final value = await _storage.read(key: _kotBluetoothEnabledKey);
      return value == 'true';
    } catch (e) {
      log("Failed to read KOT bluetooth enabled: $e");
      return false;
    }
  }

  // store KOT global paper size ('80' or '58', default '80')
  static Future<void> storeKotPaperSize(String size) async {
    try {
      await _storage.write(key: _kotPaperSizeKey, value: size);
    } catch (e) {
      log("Failed to store KOT paper size: $e");
    }
  }

  // get KOT global paper size ('80' or '58')
  static Future<String> getKotPaperSize() async {
    try {
      final value = await _storage.read(key: _kotPaperSizeKey);
      return value == '58' ? '58' : '80'; // default 80mm
    } catch (e) {
      log("Failed to read KOT paper size: $e");
      return '80';
    }
  }

  // ============ Custom Footer Settings ============

  //store custom thank you message
  static Future<void> storeCustomThankYouMessage(String message) async {
    try {
      await _storage.write(key: _customThankYouKey, value: message);
      log("Custom thank you message stored successfully");
    } catch (e) {
      log("Failed to store custom thank you message: $e");
    }
  }

  //get custom thank you message
  static Future<String?> getCustomThankYouMessage() async {
    try {
      return await _storage.read(key: _customThankYouKey);
    } catch (e) {
      log("Failed to read custom thank you message: $e");
      return null;
    }
  }

  //store custom footer message
  static Future<void> storeCustomFooterMessage(String message) async {
    try {
      await _storage.write(key: _customFooterMessageKey, value: message);
      log("Custom footer message stored successfully");
    } catch (e) {
      log("Failed to store custom footer message: $e");
    }
  }

  //get custom footer message
  static Future<String?> getCustomFooterMessage() async {
    try {
      return await _storage.read(key: _customFooterMessageKey);
    } catch (e) {
      log("Failed to read custom footer message: $e");
      return null;
    }
  }

  //store show return policy setting
  static Future<void> storeShowReturnPolicy(bool show) async {
    try {
      await _storage.write(key: _showReturnPolicyKey, value: show.toString());
      log("Show return policy setting stored successfully");
    } catch (e) {
      log("Failed to store show return policy setting: $e");
    }
  }

  //get show return policy setting
  static Future<bool> getShowReturnPolicy() async {
    try {
      final value = await _storage.read(key: _showReturnPolicyKey);
      return value == 'true';
    } catch (e) {
      log("Failed to read show return policy setting: $e");
      return false;
    }
  }

  //store return policy text
  static Future<void> storeReturnPolicyText(String text) async {
    try {
      await _storage.write(key: _returnPolicyTextKey, value: text);
      log("Return policy text stored successfully");
    } catch (e) {
      log("Failed to store return policy text: $e");
    }
  }

  //get return policy text
  static Future<String?> getReturnPolicyText() async {
    try {
      return await _storage.read(key: _returnPolicyTextKey);
    } catch (e) {
      log("Failed to read return policy text: $e");
      return null;
    }
  }

  // ============ Receipt Display Options ============

  //store show amount in words setting
  static Future<void> storeShowAmountInWords(bool show) async {
    try {
      await _storage.write(key: _showAmountInWordsKey, value: show.toString());
      log("Show amount in words setting stored successfully");
    } catch (e) {
      log("Failed to store show amount in words setting: $e");
    }
  }

  //get show amount in words setting
  static Future<bool> getShowAmountInWords() async {
    try {
      final value = await _storage.read(key: _showAmountInWordsKey);
      return value == 'true';
    } catch (e) {
      log("Failed to read show amount in words setting: $e");
      return false;
    }
  }

  //store show cash received setting
  static Future<void> storeShowCashReceived(bool show) async {
    try {
      await _storage.write(key: _showCashReceivedKey, value: show.toString());
      log("Show cash received setting stored successfully");
    } catch (e) {
      log("Failed to store show cash received setting: $e");
    }
  }

  //get show cash received setting
  static Future<bool> getShowCashReceived() async {
    try {
      final value = await _storage.read(key: _showCashReceivedKey);
      return value == 'true';
    } catch (e) {
      log("Failed to read show cash received setting: $e");
      return false;
    }
  }

  //store show balance given setting
  static Future<void> storeShowBalanceGiven(bool show) async {
    try {
      await _storage.write(key: _showBalanceGivenKey, value: show.toString());
      log("Show balance given setting stored successfully");
    } catch (e) {
      log("Failed to store show balance given setting: $e");
    }
  }

  //get show balance given setting
  static Future<bool> getShowBalanceGiven() async {
    try {
      final value = await _storage.read(key: _showBalanceGivenKey);
      return value == 'true';
    } catch (e) {
      log("Failed to read show balance given setting: $e");
      return false;
    }
  }

  // ============ Item Column Settings ============

  //store show item MRP setting
  static Future<void> storeShowItemMrp(bool show) async {
    try {
      await _storage.write(key: _showItemMrpKey, value: show.toString());
      log("Show item MRP setting stored successfully");
    } catch (e) {
      log("Failed to store show item MRP setting: $e");
    }
  }

  //get show item MRP setting
  static Future<bool> getShowItemMrp() async {
    try {
      final value = await _storage.read(key: _showItemMrpKey);
      return value != 'false'; // Default to true
    } catch (e) {
      log("Failed to read show item MRP setting: $e");
      return true;
    }
  }

  //store show item rate setting
  static Future<void> storeShowItemRate(bool show) async {
    try {
      await _storage.write(key: _showItemRateKey, value: show.toString());
      log("Show item rate setting stored successfully");
    } catch (e) {
      log("Failed to store show item rate setting: $e");
    }
  }

  //get show item rate setting
  static Future<bool> getShowItemRate() async {
    try {
      final value = await _storage.read(key: _showItemRateKey);
      return value != 'false'; // Default to true
    } catch (e) {
      log("Failed to read show item rate setting: $e");
      return true;
    }
  }

  //store show item total setting
  static Future<void> storeShowItemTotal(bool show) async {
    try {
      await _storage.write(key: _showItemTotalKey, value: show.toString());
      log("Show item total setting stored successfully");
    } catch (e) {
      log("Failed to store show item total setting: $e");
    }
  }

  //get show item total setting
  static Future<bool> getShowItemTotal() async {
    try {
      final value = await _storage.read(key: _showItemTotalKey);
      return value != 'false'; // Default to true
    } catch (e) {
      log("Failed to read show item total setting: $e");
      return true;
    }
  }

  //store show item HSN setting
  static Future<void> storeShowItemHsn(bool show) async {
    try {
      await _storage.write(key: _showItemHsnKey, value: show.toString());
      log("Show item HSN setting stored successfully");
    } catch (e) {
      log("Failed to store show item HSN setting: $e");
    }
  }

  //get show item HSN setting
  static Future<bool> getShowItemHsn() async {
    try {
      final value = await _storage.read(key: _showItemHsnKey);
      return value == 'true'; // Default to false
    } catch (e) {
      log("Failed to read show item HSN setting: $e");
      return false;
    }
  }
}
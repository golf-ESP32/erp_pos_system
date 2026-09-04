// D:\erp_pos_system\apps\erp_pos_flutter\lib\features\item_master\presentation\controllers\item_master_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemModel {
  final String id;
  final String itemCode;
  final String itemName;
  final double price;
  final double standardCost;
  final String unit;
  final String itemGroupId;
  final bool isSalesItem;
  final bool isPurchaseItem;
  final bool isRawMaterial;
  final bool isFinishedGood;
  final String unitGroupId;
  final String defaultSellUnitId;
  final String defaultBuyUnitId;
  final List<Map<String, dynamic>> barcodes;
  final bool isLotControl;

  ItemModel({
    required this.id,
    required this.itemCode,
    required this.itemName,
    this.price = 0.0,
    this.standardCost = 0.0,
    this.unit = 'ชิ้น',
    this.itemGroupId = '',
    this.isSalesItem = true,
    this.isPurchaseItem = true,
    this.isRawMaterial = false,
    this.isFinishedGood = true,
    this.unitGroupId = '',
    this.defaultSellUnitId = '',
    this.defaultBuyUnitId = '',
    this.barcodes = const [],
    this.isLotControl = false,
  });

  ItemModel copyWith({
    String? id,
    String? itemCode,
    String? itemName,
    double? price,
    double? standardCost,
    String? unit,
    String? itemGroupId,
    bool? isSalesItem,
    bool? isPurchaseItem,
    bool? isRawMaterial,
    bool? isFinishedGood,
    String? unitGroupId,
    String? defaultSellUnitId,
    String? defaultBuyUnitId,
    List<Map<String, dynamic>>? barcodes,
    bool? isLotControl,
  }) {
    return ItemModel(
      id: id ?? this.id,
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      standardCost: standardCost ?? this.standardCost,
      unit: unit ?? this.unit,
      itemGroupId: itemGroupId ?? this.itemGroupId,
      isSalesItem: isSalesItem ?? this.isSalesItem,
      isPurchaseItem: isPurchaseItem ?? this.isPurchaseItem,
      isRawMaterial: isRawMaterial ?? this.isRawMaterial,
      isFinishedGood: isFinishedGood ?? this.isFinishedGood,
      unitGroupId: unitGroupId ?? this.unitGroupId,
      defaultSellUnitId: defaultSellUnitId ?? this.defaultSellUnitId,
      defaultBuyUnitId: defaultBuyUnitId ?? this.defaultBuyUnitId,
      barcodes: barcodes ?? this.barcodes,
      isLotControl: isLotControl ?? this.isLotControl,
    );
  }
}

class ItemMasterState {
  final List<ItemModel> items;
  final ItemModel? selectedItem;
  final bool isMobileDetailExpanded;
  final bool isLoading;
  final String? errorMessage;

  ItemMasterState({
    this.items = const [],
    this.selectedItem,
    this.isMobileDetailExpanded = false,
    this.isLoading = false,
    this.errorMessage,
  });

  ItemMasterState copyWith({
    List<ItemModel>? items,
    ItemModel? selectedItem,
    bool? isMobileDetailExpanded,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ItemMasterState(
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,
      isMobileDetailExpanded:
          isMobileDetailExpanded ?? this.isMobileDetailExpanded,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ItemMasterController extends Notifier<ItemMasterState> {
  @override
  ItemMasterState build() {
    return ItemMasterState();
  }

  Future<void> loadItems() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      state = state.copyWith(
        isLoading: false,
        items: [
          ItemModel(
            id: '1',
            itemCode: 'P001',
            itemName: 'สินค้าตัวอย่าง 1',
            price: 100.0,
            standardCost: 70.0,
            barcodes: [
              {
                'barcode': '885000100001',
                'unit_id': 'ชิ้น',
                'price_level_1': 100.0,
                'price_level_2': 95.0,
                'price_level_3': 90.0,
                'price_level_4': 85.0,
                'is_default': true,
              }
            ],
          ),
          ItemModel(
            id: '2',
            itemCode: 'P002',
            itemName: 'สินค้าตัวอย่าง 2',
            price: 250.0,
            standardCost: 180.0,
            barcodes: [
              {
                'barcode': '885000100002',
                'unit_id': 'กล่อง',
                'price_level_1': 250.0,
                'price_level_2': 240.0,
                'price_level_3': 230.0,
                'price_level_4': 220.0,
                'is_default': true,
              }
            ],
          ),
        ],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectItem(ItemModel? item) {
    state = state.copyWith(selectedItem: item, isMobileDetailExpanded: true);
  }

  void resetMobileView() {
    state = state.copyWith(isMobileDetailExpanded: false);
  }

  void addItem(ItemModel newItem) {
    final updatedItems = List<ItemModel>.from(state.items)..add(newItem);
    state = state.copyWith(items: updatedItems, selectedItem: newItem);
  }

  void updateItem(int index, ItemModel updatedItem) {
    if (index >= 0 && index < state.items.length) {
      final updatedItems = List<ItemModel>.from(state.items);
      updatedItems[index] = updatedItem;
      state = state.copyWith(items: updatedItems, selectedItem: updatedItem);
    }
  }

  void deleteItem(int index) {
    if (index >= 0 && index < state.items.length) {
      final updatedItems = List<ItemModel>.from(state.items)..removeAt(index);
      state = state.copyWith(
        items: updatedItems,
        selectedItem: null,
        isMobileDetailExpanded: false,
      );
    }
  }
}

final itemMasterControllerProvider =
    NotifierProvider<ItemMasterController, ItemMasterState>(
        ItemMasterController.new);
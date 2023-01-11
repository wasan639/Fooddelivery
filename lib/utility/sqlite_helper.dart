import 'package:rabbitfood/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper{
  final String nameDatabase = 'myrabbitdatabase.db';
  final String tableDatabase = 'orderFoodTable';
  int version = 1;

  final String idColumn = 'id';
  final String idUser = 'idUser';
  final String idShopColumn = 'idShop';
  final String nameShop = 'nameShop';
  final String idFood = 'idFood';
  final String nameFood = 'nameFood';
  final String price = 'price';
  final String amount = 'amount';
  final String sum = 'sum';
  final String distance = 'distance';
  final String transport = 'transport';

  SQLiteHelper() {
    initDatabase();
  }
  
  Future initDatabase() async{
    await openDatabase(join(await getDatabasesPath(), nameDatabase),
    onCreate: (db, version) => db.execute(
      'CREATE TABLE $tableDatabase ($idColumn INTEGER PRIMARY KEY, $idUser TEXT,$idShopColumn TEXT,$nameShop TEXT,$idFood TEXT,$nameFood TEXT,$price TEXT,$amount TEXT,$sum TEXT,$distance TEXT,$transport TEXT)'),
      version: version);
  }

  Future<Database> connectedDatabase() async {
    return openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future insertDataToSQLite(CartModel cartModel) async {
    Database database = await connectedDatabase();
    try {
      database.insert(
        tableDatabase,
        cartModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('e insertData == ${e.toString()}');
    }
  }

  Future<List<CartModel>> readAllDataFromSQLite(int id) async {
    Database database = await connectedDatabase();
    List<CartModel> cartModels = [];

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? id = preferences.getString('id');

    List<Map<String, dynamic>> maps = await database.query(tableDatabase, where: '$idUser = $id');

    for (var map in maps) {
      CartModel cartModel = CartModel.fromJson(map);
      cartModels.add(cartModel);
    }

    return cartModels;
  }

  Future delteDataWhereId(int id) async {
    Database database = await connectedDatabase();
    try {
      await database.delete(tableDatabase, where: '$idColumn = $id');
    } catch (e) {
      print('e delete ==> ${e.toString()}');
    }
  }

  Future delteAllData() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(tableDatabase);
    } catch (e) {
      print('e delete ==> ${e.toString()}');
    }
  }


}
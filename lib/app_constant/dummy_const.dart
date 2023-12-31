import 'package:expense_app/app_constant/img_const.dart';

import '../models/category_model.dart';

class ExpCategorys {
  static final List<CategoryModel> mCategory = [
    CategoryModel(
        catTitle: 'Groceries', catImgPath: ImgPath.groceriesImg, catId: 0),
    CategoryModel(catTitle: 'Gym', catImgPath: ImgPath.gymImg, catId: 1),
    CategoryModel(catTitle: 'Food', catImgPath: ImgPath.foodImg, catId: 2),
    CategoryModel(
        catTitle: 'Clothes', catImgPath: ImgPath.clothesImg, catId: 3),
    CategoryModel(catTitle: 'Study', catImgPath: ImgPath.studyImg, catId: 4),
    CategoryModel(catTitle: 'Travel', catImgPath: ImgPath.travelImg, catId: 5),
    CategoryModel(catTitle: 'Movies', catImgPath: ImgPath.moviesImg, catId: 6),
    CategoryModel(catTitle: 'Rent', catImgPath: ImgPath.rentImg, catId: 7),
    CategoryModel(catTitle: 'Coffee', catImgPath: ImgPath.coffeeImg, catId: 8),
    CategoryModel(catTitle: 'Petrol', catImgPath: ImgPath.petrolImg, catId: 9),
    CategoryModel(catTitle: 'Snacks', catImgPath: ImgPath.snacksImg, catId: 10),
    CategoryModel(
        catTitle: 'Medicine', catImgPath: ImgPath.medicineImg, catId: 11),
  ];
}

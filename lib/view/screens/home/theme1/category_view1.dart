import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/title_widget.dart';
import 'package:sixam_mart/view/screens/home/widget/category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

class CategoryView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    return GetBuilder<StoreController>(builder: (storeController) {
      return (storeController.categoryList != null && storeController.categoryList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TitleWidget(title: 'categories'.tr, onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 65,
                        child: storeController.categoryList != null
                            ? ListView.builder(
                                controller: _scrollController,
                                itemCount: storeController.categoryList.length > 15 ? 15 : storeController.categoryList.length,
                                padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 1),
                                    child: InkWell(
                                      onTap: () => storeController.setCategoryIndex(index),
                                      // Get.toNamed(RouteHelper.getCategoryItemRoute(
                                      //   storeController.categoryList[index].id,
                                      //   storeController.categoryList[index].name,
                                      // )),
                                      child: SizedBox(
                                        width: 75,
                                        child: Container(
                                          height: 65,
                                          width: 75,
                                          margin: EdgeInsets.only(
                                            left: index == 0 ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                            right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                          ),
                                          child: Stack(children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                              child: CustomImage(
                                                image: '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${storeController.categoryList[index].image}',
                                                height: 65,
                                                width: 75,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 2),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(Dimensions.RADIUS_SMALL)),
                                                  color: index == storeController.categoryIndex ? Theme.of(context).primaryColor.withOpacity(0.8) : Colors.transparent,
                                                ),
                                                child: Text(
                                                  storeController.categoryList[index].name,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: robotoMedium.copyWith(
                                                    fontSize: Dimensions.fontSizeExtraSmall,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : CategoryShimmer(storeController: storeController),
                      ),
                    ),
                    ResponsiveHelper.isMobile(context)
                        ? SizedBox()
                        : storeController.categoryList != null
                            ? Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (con) => Dialog(
                                          child: Container(
                                            height: 550,
                                            width: 600,
                                            child: CategoryPopUp(
                                              categoryController: Get.find<CategoryController>(),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Theme.of(context).primaryColor,
                                        child: Text('view_all'.tr, style: TextStyle(fontSize: Dimensions.PADDING_SIZE_DEFAULT, color: Theme.of(context).cardColor)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              )
                            : CategoryAllShimmer(storeController: storeController)
                  ],
                ),
              ],
            );
    });
  }
}

class CategoryShimmer extends StatelessWidget {
  final StoreController storeController;
  CategoryShimmer({@required this.storeController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: 14,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: SizedBox(
              width: 75,
              child: Container(
                height: 65,
                width: 65,
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),
                child: Shimmer(
                  duration: Duration(seconds: 2),
                  enabled: storeController.categoryList == null,
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  final StoreController storeController;
  CategoryAllShimmer({@required this.storeController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: storeController.categoryList == null,
          child: Column(children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              ),
            ),
            SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}

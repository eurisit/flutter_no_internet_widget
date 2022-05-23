import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_no_internet_widget/src/_cubit/internet_cubit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

///FlutterNoInternetWidget
class FlutterNoInternetWidget extends StatelessWidget {
  ///FlutterNoInternetWidget Constructor
  const FlutterNoInternetWidget({
    Key? key,
    this.height,
    this.width,
    this.offline,
    this.online,
    this.lookupUrl,
    this.loadingWidget,
  }) : super(key: key);

  ///Width of the widget
  final double? width;

  ///Height of the widget
  final double? height;

  ///Widget to be displayed when there is no internet connection
  final Widget? offline;

  ///Widget to be displayed when there is internet connection
  final Widget? online;

  ///This widget will be displayed when the
  ///cubit is busy checking the internet status
  final Widget? loadingWidget;

  ///Lookup Url
  final String? lookupUrl;

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return BlocProvider<InternetCubit>(
          create: (context) => InternetCubit(
            urlLookup: lookupUrl,
          ),
          child: Builder(
            builder: (_) {
              return BlocBuilder<InternetCubit, InternetState>(
                builder: (_, state) {
                  if (state.cubitStatus == CubitStatus.busy) {
                    return loadingWidget ??
                        const Center(
                          child: CircularProgressIndicator(),
                        );
                  }
                  return SizedBox(
                    width: width ?? 100.0.w,
                    height: height ?? 100.0.h,
                    child: state.cubitStatus == CubitStatus.none &&
                            state.internetStatus == InternetStatus.connected
                        ? _getOnlineWidget()
                        : _getOfflineWidget(),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _getOnlineWidget() {
    if (online == null) {
      return const Text('Online');
    }
    return online!;
  }

  Widget _getOfflineWidget() {
    if (offline == null) {
      return const Text('Offline');
    }
    return offline!;
  }
}

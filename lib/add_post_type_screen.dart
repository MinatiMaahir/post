  import 'dart:html';

import 'package:buttons_functions/Home_screen.dart';
import 'package:buttons_functions/post_controller.dart';
import 'package:flutter/material.dart';
import 'flutter_riverpod/flutter_riverpod.dart';


class AddPostTypeScreen extends StatefulWidget {
  final String type;
  const AddPostTypeScreen ({
    super.key,
    required this.type
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends State<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedcommunity;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose()
  }


  void selectBannerImage() async {
    final res = await picklmage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost(){
    if(widget.type == 'image' && bannerFile!= null && titleController.text.isNotEmpty){
      ref.read(postControllerProvider.notifier).shareTextPost(
        context: context,
        title: titleController.text.trim(),
        selectedcommunity: selectedCommunity??communities[0],
        file: bannerFile,
      );
    } else if(widget.type == 'text' && titleController.text.isNotEmpty){
      ref.read(postControllerProvider.notifier).shareImagePost(
        context: context,
        title: titleController.text.trim(),
        selectedcommunity: selectedCommunity??communities[0],
        description: descriptionController.text.trim(),
      );
    } else if(widget.type == 'link' &&  titleController.text.isNotEmpty && linkController.text.isNotEmpty){
      ref.read(postControllerProvider.notifier).shareLinkPost(
        context: context,
        title: titleController.text.trim(),
        selectedcommunity: selectedCommunity??communities[0],
        link: linkController.text.trim(),
      );
    } else{
      showSnackBar(context, 'Please return all the feilds')
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(onPressed: sharePost,
            child: const Text('Share'),
          ),
        ],
      ),
      body:isLoading
          ? const Loader()
        :Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
            controller: titleController,
            decoration: const InputDecoration(
                filled: true,
                hintText: 'Enter Title here' ,
                border: InputBorder. none,
                contentPadding: EdgeInsets.all(18),

              ),
              maxLength: 30,
            ),
            const SizedBox(height: 10),
            if(isTypeImage)
            GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius : const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap. round,
                        color: currentTheme.textTheme.bodyText2!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius. circular(10) ,
                          ) ,
                          child: bannerFile != null
                              ?Image. file(bannerFile!)
                              : const Center(
                               child: Icon(
                                 Icons. camera att outlined,
                                  size: 40,
                              ) ,
                            )
            ),
            ),
          ),
            if(isTypeText)
              TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Enter description here' ,
                    border: InputBorder. none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLines: 5,
              ),
            if(isTypeLink)
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter Link here' ,
                  border: InputBorder. none,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLines: 5,
              ),
            const SizedBox(height: 25),
            const Align(alignment:Alignment.topLeft,
              child: Text('Select Community',
              ),
            ),

            ref.watch(userCommunitiesProvider).when(
                data: (data) {
                  communities = data;

                  if(data.isEmpty){
                    return const SizedBox();
                  }

                  return DropdownButton(
                    value: selectedcommunity??data[0],
                    items: data.map(
                            (e) =>DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                            ),
                       )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedcommunity = val;
                      });
                    },
                  );
                } ,
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
            ),
        ],
        ),
      ),
    );
  }
}

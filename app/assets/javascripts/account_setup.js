$(document).ready(function() {
  $(document).on("change", ".account-signup-category-forms .parent-categories select", function() {
    var _this = this;
    var parentId = $(this).find(":selected").val();
    var categoriesControllerEndpoint = $(".categories-list-path").text()+"/"+parentId+".json";

    $.ajax({
      url: categoriesControllerEndpoint,
      methid: "GET",
			dataType: "json",
      success: function(json) {
        var subCategoriesOptions = "<option value=''>-- Select skills --</option>";

        $.each(json, function(i, item) {
          subCategoriesOptions += "<option value='"+item.id+"'>"+item.display_name+"</option>";
        });

        $(_this).parent().parent().find(".sub-categories-select select").html(subCategoriesOptions);
      }
    });
  });

  //for post a project category change - checkboxes
  $(document).on("change", ".account-signup-category-forms .parent-categories-1 select", function() {
    var _this = this;
    var parentId = $(this).find(":selected").val();
    var listing_id = $(".listing_id").text();
    var categoriesControllerEndpoint = $(".categories-list-path").text()+"/"+parentId+".js";

    $.ajax({type: "GET"
          , url: categoriesControllerEndpoint
          , dataType: "script"
          ,data: { listing_id: listing_id}
          , success: function(js) {}
    });     
  });



  $('.upload-options').bind("DOMSubtreeModified",function(){
    $('.upload-options input[type="file"]').last().click();
  });

  // Card live edit of skills
	$(document).on('nested:fieldAdded', function(event){
		$("form").validator('update');

    $(".account-setup-category .skills-category-select").each(function(event) {
      $(this).bind("propertychange change", function(event) {
        result = "";
        i = 0;
        $(".account-setup-category .skills-category-select").each(function(event) {
          i++;
          if ($(this).val() > 0) {
            result += $(this).find("option:selected").text();

            if(i && (i % 2 === 0)) {
              result += "<br />";
            };
            if(i && (i % 2 === 1)) {
              result += " | ";
            };
          };
        });

        $("#card_main_skills .card-text").html(result);
      });
	  });
	});

  // Add default 1 skill
	$(".add_more_skils").click();

  // Card live edit of main title
  $("#company-name").bind("propertychange change click keyup input paste", function(event) {
    var value = $(this).val();
    $("#card_main_title .card-text").text(value);
   });

  $("#main_project_price_input").bind("propertychange change click keyup input paste", function(event) {
    var value = $(this).val();
    console.log(value);
    $("#card_main_price .card-text").text(value);
   });

  // Card live edit of main description
  $("#main_description_input").bind("propertychange change click keyup input paste", function(event) {
    var value = $(this).val();
    console.log(value);
    $("#card_main_description .card-text").text(value);
   });

  // Card live edit of main image
  $("#main_image_url").bind("propertychange change click keyup input paste", function(event) {
    if (this.files && this.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $("#card_main_image").attr("src", e.target.result);
      };
      reader.readAsDataURL(this.files[0]);
    }
   });

  $('body').on('change', 'input[type="file"].file_preupload', function(){

    var index = $(".file_preupload").index(this);

    index = index % 3;
    console.log(index);

    if (this.files && this.files.length > 0) {
      var reader = new FileReader();
      var id = '#card_main_image_' + index; 
      reader.onload = function (e) {
        $(id).attr("src", e.target.result);
      };
      reader.readAsDataURL(this.files[0]);
    } 
  })   

  $('body').on('change', 'input[type="file"].file_promoupload', function(){

    var index = $(".file_promoupload").index(this);

    index = index % 3;
    console.log(index);

    if (this.files && this.files.length > 0) {
      var reader = new FileReader();
      var id = '#promo_image_' + index; 
      reader.onload = function (e) {
        $(id).attr("src", e.target.result);
      };
      reader.readAsDataURL(this.files[0]);
    } 
  })   

  $('body').on('click', '.image_remove', function(){
    var index = $(".image_remove").index(this);

    index = index % 3;
    console.log(index);

    var id = '#card_main_image_' + index; 
    switch(index) {
      case 0:
          $(id).attr("src", "/assets/gardenshed0.jpg");
          break;
      case 1:
          $(id).attr("src", "/assets/gardenshed1.jpg");
          break;
      case 2:
          $(id).attr("src", "/assets/gardenshed2.jpg");
          break;
      default:
          $(id).attr("src", "/assets/gardenshed0.jpg");
    }

  });

  $('body').on('click', '.promo_image_remove', function(){
    var index = $(".promo_image_remove").index(this);

    index = index % 3;
    console.log(index);

    var id = '#promo_image_' + index; 
    switch(index) {
      case 0:
          $(id).attr("src", "/assets/promo-pic0.jpg");
          break;
      case 1:
          $(id).attr("src", "/assets/promo-pic1.jpg");
          break;
      case 2:
          $(id).attr("src", "/assets/promo-pic2.jpg");
          break;
      default:
          $(id).attr("src", "/assets/promo-pic0.jpg");
    }

  });

  // Card live edit of location
  $(".main_location_input").each(function() {
    $(this).bind("propertychange change click keyup input paste", function(event) {
      var result = "";
      $(".main_location_input").each(function() {
        result += $(this).val()+", ";
      });

      $("#card_main_location .card-text").text(result);
    });
  });

  $('#project_valid_until').datepicker({
    format: 'mm-dd-yyyy',
    startDate: '+0d',
    autoclose: true
  });
});

// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery.sortable.min

jQuery(function(){
	
	$('.other_informations a').toggle(
		function(e){
			e.preventDefault();
			$("ol li:hidden").slideDown();
			$(this).text("Moins d'informations");
		},
		function(e){
			e.preventDefault();
			$("ol li.has_content:nth-child(n+8)").slideUp();
			$(this).text("+ Plus d'informations");
		}
	)
	
	$('.tools .edit').toggle(
		function(e){
			e.preventDefault();
			$(this).parents('.content').siblings('.subform').slideDown();
			$(this).parents('.content').hide();
		},
		function(e){
			e.preventDefault();
			$(this).parents('.content').siblings('.subform').slideUp();
			$(this).parents('.content').show();
		}
	);
	
	var checkVisibilityOfPlusButton = function(){
		if($("ol li.has_content").length > 7){
			$('.other_informations').fadeIn();
		}
		else{
			$('.other_informations').fadeOut();
		}
	}
	
	checkVisibilityOfPlusButton();
	
	$(".delete").bind("ajax:complete", 
		function() {
			that = $(this).parents('li');
			that.effect('drop', {}, 500,
				function(){
					that.remove();
					checkVisibilityOfPlusButton()
				}
			);
		}
	);
	
	$(".reorder a").click(function(e){
		e.preventDefault();
		
		$("ol li.has_content").each(function(index, e){
			e = $(e).find('.subform .score')
			e.val(index + 1)
		})
		
		$(this).parents('form').submit()
	})
	
	$('form .close').click(function(e){
		e.preventDefault();
		
		$(this).parents('.subform').slideUp();
		$(this).parents('.subform').siblings('.content').show();
	});


	$('#content ol.sortable').sortable({
		items: ':not(.no_content)' 
	});
	
	$('#content ol.sortable').on('sortupdate', function(e, ui) {
		$('.reorder:hidden').fadeIn().effect('pulsate', {times: 1});
	});
})
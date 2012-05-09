jQuery(function(){

	$('*[data-behaviour=fadeIn]').each(function(){
		var _start = $(this).data('fadein-initial', $(this).css('opacity'))
	
		$(this).hover(
			function(){
				$(this).animate({opacity:  1})
			},
			function(){
				$(this).animate(
					{
						opacity:  $(this).data('fadein-initial')
					}
				)
			}
		)
	})

	$('header #login a.js').click(function(e){
		e.preventDefault();
	
		$(this).parents('#login').children('a, form').fadeToggle('normal', function(){
			$("#author_email").focus();
		});
	});

	$('#content a.close').click(function(e){
		e.preventDefault();
		$(this).parents('.closable').slideUp('normal');
	});

	$('header a.close').live('click', function(e){
		e.preventDefault();
		$(this).parents('.closable').animate({top: 0}, 'fast', function(){
			$(this).animate({top: $(this).height()*-1}, function(){
				$(this).remove();
			})
		})
	});
	
	var showNotices = function(){
		$('header #notices li').each(function(){
			$(this).animate({top: -30}, function(){});
		})
	}
	
	window.setTimeout(showNotices, 250);
	
})
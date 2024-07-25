/// @desc
// feather ignore GM2017

#macro	concurrent_split function()

function concurrent_for(_struct)
{
	
}

concurrent_for({
	iteration : 0,
	condition : function() { return (iteration < 200) },
	increment : function() { return (iteration++); },
	resume: function()
	{
			
	},
	body: [
	concurrent_split 
	{
		concurrent_for({
			iteration : 0,
			condition : function() { return (iteration < 200) },
			increment : function() { return (iteration++); },
			body: [
			concurrent_split 
			{
		
			}, 
			concurrent_split 
			{
		
			}, 
			concurrent_split 
			{
		
			}]
		});
	}, 
	concurrent_split 
	{
		
	}, 
	concurrent_split 
	{
		
	}]
});








({
	doInit : function(cmp, event, helper) {
		helper.init(cmp, event);
	},
    onChange : function(cmp, event, helper){
        helper.changePlay(cmp, event);
    },
	viewAllRecommendations : function(cmp, event, helper) {
		helper.navigateToRecs(cmp, event);
	}
})
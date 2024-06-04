function showBreakDownStructure() {
    $.ajax({ 
      type: "GET", 
      url: '/equipment',
      data: null,
      dataType: "script"
    });    
  }
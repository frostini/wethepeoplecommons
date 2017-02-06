var $select;
$select = $('#select-to').selectize({
    maxItems: 4,
    searchField: "name",
    labelField: 'name',
    valueField: 'id',
    options:[{id: 1, name: "Web Development"},
             {id: 2, name: "Mobile Apps"},
             {id: 3, name: "UI/UX Design"},
             {id: 4, name: "Graphic Design"},
             {id: 5, name: "Product Management"},
             {id: 6, name: "Data Science"},
             {id: 7, name: "Marketing"},
             {id: 8, name: "Business Development"},
             {id: 9, name: "Analytics"},
             {id: 10, name: "Copy Writting"},
             {id: 11, name: "Event Planning"},
             {id: 11, name: "Photo/Video"},
             {id: 12, name: "Other"}
            ]
});
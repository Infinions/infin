import BulmaTagsInput from '@creativebulma/bulma-tagsinput';

BulmaTagsInput.attach('input[data-type="tags"], input[type="tags"], select[data-type="tags"], select[type="tags"]', {
    allowDuplicates: false,
    caseSensitive: true,
    clearSelectionOnTyping: false,
    closeDropdownOnItemSelect: true,
    delimiter: ',',
    freeInput: true,
    highlightDuplicate: true,
    highlightMatchesString: true,
    itemValue: undefined,
        itemText: undefined,
    maxTags: undefined,
    maxChars: undefined,
    minChars: 1,
    noResultsLabel: 'No results found',
    placeholder: '',
    removable: true,
    searchMinChars: 1,
    searchOn: 'text',
    selectable: true,
    source: undefined,
    tagClass: 'is-rounded',
    trim: true
});

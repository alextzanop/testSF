import { LightningElement, wire } from 'lwc';
import getLibraries from '@salesforce/apex/LibraryController.getLibraries';
import getBooksForLibrary from '@salesforce/apex/LibraryBooksController.getBooksForLibrary';
import getLibraryUsers from '@salesforce/apex/LibraryUsersController.getLibraryUsers';
import search from '@salesforce/apex/LibrarySearchController.search';

export default class SearchLib extends LightningElement {

    selectedValue = '';
    dropdownOptions = [];
    errorMessage = '';
    isLoading = true;

    bookData = [];
    bookColumns = [{ label: 'Name', fieldName: 'Name' }, { label: 'Total copies', fieldName: 'Total_Number_of_Copies__c' }, { label: 'Available', fieldName: 'Availables_copies__c' }];

    userData = [];
    userColumns = [{ label: 'Name', fieldName: 'Name' }, { label: 'Email', fieldName: 'Email' }, { label: 'Gender', fieldName: 'Gender__c' }];


    // @wire(getLibraryUsers)
    // wiredUsers({ error, data }) {
    //     if (data) {
    //         this.userData = data;
    //     } else if (error) {
    //         this.errorMessage = 'Error loading users: ' + error.message;
    //     }
    // }

    @wire(getLibraries)
    wiredLibraries({ error, data }) {
        if (data) {
            this.dropdownOptions = data.map(library => ({
                label: library.Name,
                value: library.Id
            }));
            this.isLoading = false;
        } else if (error) {
            this.errorMessage = 'Error loading libraries: ' + error.message;
            this.isLoading = false;
        }
    }

    handleLibraryChange(event) {

        this.selectedValue = event.detail.value;

        if (this.selectedValue) {
            this.loadBooksForLibrary(this.selectedValue);
            this.loadUsersForLibrary(this.selectedValue);
            this.isLoading = true;
        } else {
            this.bookData = [];
            this.userData = [];
            this.isLoading = false;
        }

    }

    loadBooksForLibrary(libraryId) {
        getBooksForLibrary({ libraryId })
            .then(result => {
                this.bookData = result;
                this.isLoading = false;
            })
            .catch(error => {
                this.errorMessage = 'Error loading books: ' + error.message;
                this.isLoading = false;
            });
    }

    loadUsersForLibrary(libraryId) {
        getLibraryUsers({ libraryId })
            .then(result => {
                this.isLoading = false;
                this.userData = result;
            })
            .catch(error => {
                this.errorMessage = 'Error loading users: ' + error.body.message;
                this.isLoading = false;
            });
    }


    handleSearchInputChange(event) {
        this.searchTerm = event.target.value;
    }

    handleSearchClick() {
        if (!this.searchTerm) {
            this.errorMessage = 'Please enter a search term.';
            return;
        }
        this.selectedValue = null;
        this.errorMessage = '';
        this.isLoading = true;
        console.log(' Starting search for:', this.searchTerm);
        this.searchInputTerm(this.searchTerm);
    }

    searchInputTerm(searchTerm) {

        this.isLoading = true;

        search({ searchTerm })
            .then((wrapper) => {
                console.log(' Wrapper result:', wrapper);
                this.bookData = wrapper.books;
                this.userData = wrapper.users;
                this.isLoading = false;
            })
            .catch(error => {
                console.error('Error during search:', error);
                this.errorMessage = error?.body?.message || 'Error searching';
                this.isLoading = false;
            });

    } catch(error) {
        console.error('Unexpected error:', error);
        this.errorMessage = 'An unexpected error occurred: ' + error.body.message;
        this.isLoading = false;
    } s
}
import UserService from './UserService';

class CustomerService{
    create() {
        UserService.create();
        console.log('Create Customer');
    }
}

const instance = new CustomerService();
export default instance;
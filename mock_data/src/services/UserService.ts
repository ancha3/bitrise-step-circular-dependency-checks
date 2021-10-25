import CustomerService from './CustomerService';

class UserService {
    create() {
        console.log('Create user');
    }

    get() {
        // @ts-ignore
        let customer = CustomerService.get();
        console.log({customer});
    }
}
const instance = new UserService();
export default instance;
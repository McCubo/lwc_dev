import { LightningElement, wire } from 'lwc';
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext,
    publish
} from 'lightning/messageService';
import optionSelected from '@salesforce/messageChannel/optionSelect__c';

export default class ExposedEventOne extends LightningElement {

    selectedoption;
    subscription;
    @wire(MessageContext)
    messageCtx;

    get optionMessage() {
        return this.selectedoption;
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageCtx,
                optionSelected,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    handleMessage(message) {
        console.log('message: %O', JSON.stringify(message));
        this.selectedoption = message.optionValue;
    }
    
    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    fireEvent(event) {
        let clickedOption = event.currentTarget.dataset.optvalue;
        const payload = { optionValue: clickedOption };
        publish(this.messageCtx, optionSelected, payload);
    }
}
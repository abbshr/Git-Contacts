var LoginAndRegister = React.createClass({
  render: function () {
    return (
      <form class="ui form">
        <div class="two fields">
          <div class="required field">
            <div class="ui icon input">
              <input type="text" name="email" placeholder="Email" ref="email" />
              <i class="user icon"></i>
            </div>
          </div>
          <div class="required field">
            <div class="ui icon input">
              <input type="password" name="password" placeholder="Password" ref="password" />
              <i class="lock icon"></i>
            </div>
          </div>
          <button class="ui submit button" type="button" onClick={ this.onClick } url={ this.props.register }>
            Register
          </button>
          <button class="ui submit button" type="button" onClick={ this.onClick } url={ this.props.login }>
            Login
          </button>
        </div>
      </form>
    );
  },
  onClick: function (e) {
    this.onSubmit(e.target.getAttribute('url'));
  },  
  onSubmit: function (url) {
    var auth = {
      "email": this.refs.email.getDOMNode().value.trim(),
      "password": this.refs.password.getDOMNode().value.trim()
    };
    this.props.onSubmit(url, auth);
  }
});

var App = React.createClass({
  render: function () {
    if (this.state.login) {
      return (<Contacts>);
    } else {
      if (this.state.err) {
        return (<Error status={ this.state.status } err={ this.state.err }>);
      } else {
        return (<LoginAndRegister login='/login' register='/register' onSubmit={ this.handleSubmit }>);
      }
    }
    return (<LoginAndRegister login='/login' register='/register' onSubmit={this.handleSubmit}>);
  },
  handleSubmit: function (url, auth) {
    $.ajax({
      url: url,
      dataType: 'json',
      type: 'POST',
      data: auth,
      success: (function (data) {
              this.setState({ login: true });
            }).bind(this),
      error: (function (xhr, status, err) {
              this.setState({ err: err, status: status });
            }).bind(this)
    });
  },
  getInitialState: function () {
    return { 
      login: false,
      err: null,
      status: null
    };
  }
});

var Contacts = React.createClass({
  render: function () {
    return (
      <div class="ui "></div>
    );
  }
});
var Error = React.createClass({
  render: function () {
    return (
      <div class="ui floating negative message">
        <i class="close icon"></i>
        <div class="header">
          this.props.status
        </div>
        <p>this.props.err</p>
      </div>
    );
  },
  componentDidMount: function () {
    $('.message .close').on('click', function() {
      $(this).closest('.message').fadeOut();
    });
  }
});

React.render(<App />, $('#main'));
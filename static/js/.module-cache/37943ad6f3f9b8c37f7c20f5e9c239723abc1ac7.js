var LoginAndRegister = React.createClass({displayName: "LoginAndRegister",
  render: function () {
    return (
      React.createElement("div", {class: "row"}, 
        React.createElement("div", {class: "col-md-5"}, 
          React.createElement("form", {class: "form-horizontal"}, 
            React.createElement("div", {class: "form-group"}, 
              React.createElement("label", {for: "inputEmail3", class: "col-sm-2 control-label"}, "Email"), 
              React.createElement("div", {class: "col-sm-7"}, 
                React.createElement("input", {type: "email", class: "form-control", id: "inputEmail3", placeholder: "Email"})
              )
            ), 
            React.createElement("div", {class: "form-group"}, 
              React.createElement("label", {for: "inputPassword3", class: "col-sm-2 control-label"}, "Password"), 
              React.createElement("div", {class: "col-sm-7"}, 
                React.createElement("input", {type: "password", class: "form-control", id: "inputPassword3", placeholder: "Password"})
              )
            ), 
            React.createElement("div", {class: "form-group"}, 
              React.createElement("div", {class: "col-sm-offset-2 col-sm-10"}, 
                React.createElement("div", {class: "row"}, 
                  React.createElement("div", {class: "col-sm-2"}, 
                    React.createElement("button", {type: "submit", class: "btn btn-default"}, "登录")
                  ), 
                  React.createElement("div", {class: "col-sm-3"}, 
                    React.createElement("button", {type: "submit", class: "btn btn-primary"}, "注册试用")
                  )
                )
              )
            )
          )
        )
      )
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

var App = React.createClass({displayName: "App",
  render: function () {
    return (
      React.createElement("div", null, 
      React.createElement(Screen, null), 
      React.createElement(LoginAndRegister, {onSubmit: this.handleSubmit})
      )
    );
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

var Contacts = React.createClass({displayName: "Contacts",
  render: function () {
    return (
      React.createElement("div", {class: "ui "})
    );
  }
});
var Error = React.createClass({displayName: "Error",
  render: function () {
    return (
      React.createElement("div", {class: "ui floating negative message"}, 
        React.createElement("i", {class: "close icon"}), 
        React.createElement("div", {class: "header"}, 
          "this.props.status"
        ), 
        React.createElement("p", null, "this.props.err")
      )
    );
  },
  componentDidMount: function () {
    $('.message .close').on('click', function() {
      $(this).closest('.message').fadeOut();
    });
  }
});
var Screen = React.createClass({displayName: "Screen",
  render: function () {
    return (
      React.createElement("div", {className: "row"}, 
        React.createElement("div", {className: "col-md-12"}, 
          React.createElement("div", {className: "jumbotron"}, 
            React.createElement("h1", null, React.createElement("i", {className: "fa fa-git-square fa-3"}), " Git Contacts"), 
            React.createElement("p", null, "在Git上搭建通讯录服务"), 
            React.createElement("p", {className: "text-right"}, 
              React.createElement("a", {className: "btn btn-primary btn-lg", href: "/inspect", role: "button"}, "了解它是如何工作的")
            )
          )
        )
      )
    );
  }
});

React.render(React.createElement(App, null), $('#main'));
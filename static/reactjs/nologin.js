var App = React.createClass({
  render: function () {
    var description = "在Git上搭建通讯录服务";
    var title = "Git Contacts";

    if (this.state.err)
      return (
        <div>
          <Error err={this.state.err} status="Error: " alertType="danger" onClosed={this.onAlertClosed} />
          <Screen description={description} title={title} />
          <LoginAndRegister onSubmit={this.handleSubmit} />
        </div>
      );
    else
      return (
        <div>
          <Screen description={description} title={title} />
          <LoginAndRegister onSubmit={this.handleSubmit} />
        </div>
      );
  },
  onAlertClosed: function () {
    this.setState({ err: null });
  },
  handleSubmit: function (url, auth) {
    $.ajax({
      url: url,
      dataType: 'json',
      type: 'POST',
      data: JSON.stringify(auth),
      success: function (data) {
        window.location.reload();
      }.bind(this),
      error: function (xhr, status, err) {
        this.setState({ err: xhr.responseJSON });
      }.bind(this)
    });
  },
  getInitialState: function () {
    return { err: null };
  }
});

var LoginAndRegister = React.createClass({
  render: function () {
    return (
      <div className="row">
        <div className="col-md-5">
          <form className="form-horizontal">
            <div className="form-group">
              <label htmlFor="inputEmail3" className="col-sm-2 control-label">Email</label>
              <div className="col-sm-7">
                <input type="email" className="form-control" placeholder="Email" ref='email' />
              </div>
            </div>
            <div className="form-group">
              <label htmlFor="inputPassword3" className="col-sm-2 control-label">Password</label>
              <div className="col-sm-7">
                <input type="password" className="form-control"  placeholder="Password" ref='password' />
              </div>
            </div>
            <div className="form-group">
              <div className="col-sm-offset-2 col-sm-10">
                <div className="row">
                  <div className="col-sm-2">
                    <input type="button" className="btn btn-default" data-url="/login" onClick={this.onClick} value="登录" />
                  </div>
                  <div className="col-sm-3">
                    <input type="button" className="btn btn-primary" data-url="/register" onClick={this.onClick} value="注册试用" />
                  </div>
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    );
  },
  onClick: function (e) {
    e.preventDefault();
    this.onSubmit(e.target.dataset['url']);
  },  
  onSubmit: function (url) {
    var auth = {
      "email": this.refs.email.getDOMNode().value.trim(),
      "password": this.refs.password.getDOMNode().value.trim()
    };
    this.props.onSubmit(url, auth);
  }
});

var Error = React.createClass({
  render: function () {
    return (
      <div id='alert' className={"alert alert-"+this.props.alertType+" alert-dismissible fade in"} role="alert">
        <button type="button" className="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">×</span>
        </button>
        <strong>{this.props.status}</strong>
        <p>{this.props.err}</p>
      </div>
    );
  },
  componentDidMount: function () {
    $('#alert').on('closed.bs.alert', this.props.onClosed);
  }
});
var Screen = React.createClass({
  render: function () {
    return (
      <div className="row">
        <div className="col-md-12">
          <div className="jumbotron">
            <h1><i className="fa fa-git-square fa-3"></i> {this.props.title}</h1>
            <p>{this.props.description}</p>
            <p className="text-right">
              <a className="btn btn-primary btn-lg" href="/inspect" role="button">了解它是如何工作的</a>
            </p>
          </div>
        </div>
      </div>
    );
  }
});

React.render(<App />, document.querySelector('#main'));